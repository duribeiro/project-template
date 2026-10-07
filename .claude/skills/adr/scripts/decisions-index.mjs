#!/usr/bin/env node
import { readdirSync, readFileSync, writeFileSync, existsSync } from "node:fs";
import { join, relative, dirname, basename, resolve, sep } from "node:path";

const DECISION_FILE = /^(\d{4})-.+\.md$/;
const FRONT_MATTER = /^---\n([\s\S]*?)\n---/;
const MARKDOWN_FILE_LINK = /\]\(([^)#:\s]+\.md)\)/g;
const CODE_BLOCK = /```[\s\S]*?```/g;
const INDEX_HEADING = /^## Índice$/m;
const INDEX_NOTE = "_Tabela gerada pelo índice. Não editar à mão._";

const STATE_LABELS = {
  proposta: "proposta",
  "em-vigor": "em vigor",
  substituida: "substituída",
  "substituida-em-parte": "em vigor, parte substituída",
  suspensa: "suspensa",
  pendente: "pendente",
};
const NUMBER_LISTS = { substitui: "supersedes", substituida_por: "supersededBy", relacionadas: "related" };
const REQUIRED_FIELDS = ["numero", "titulo", "data", "estado", "substitui", "substituida_por", "relacionadas"];
const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;
const RECIPROCAL_FIELDS = { supersedes: "supersededBy", supersededBy: "supersedes", related: "related" };
const RELATION_WORDING = { supersedes: "substitui a", supersededBy: "é substituída pela", related: "é relacionada à" };

const toPosix = (path) => path.split(sep).join("/");
const readText = (path) => readFileSync(path, "utf8").replace(/\r\n/g, "\n");
const parseList = (raw = "") => raw.replace(/^\[|\]$/g, "").split(",").map((item) => item.trim()).filter(Boolean);

function parseFrontMatter(markdown) {
  const block = markdown.match(FRONT_MATTER);
  if (!block) return null;
  const entries = block[1]
    .split("\n")
    .filter((line) => line.includes(":"))
    .map((line) => {
      const separator = line.indexOf(":");
      return [line.slice(0, separator).trim(), line.slice(separator + 1).trim()];
    });
  return Object.fromEntries(entries);
}

function scanFolder(root) {
  const found = { decisionPaths: [], readmePaths: [], folders: [] };
  const visit = (folder) => {
    found.folders.push(folder);
    for (const entry of readdirSync(folder, { withFileTypes: true })) {
      const path = join(folder, entry.name);
      if (entry.isDirectory()) visit(path);
      else if (entry.name === "README.md") found.readmePaths.push(path);
      else if (DECISION_FILE.test(entry.name)) found.decisionPaths.push(path);
    }
  };
  visit(root);
  return found;
}

function loadDecision(path, root, errors) {
  const location = toPosix(relative(root, path));
  const markdown = readText(path);
  const fields = parseFrontMatter(markdown);
  if (!fields) {
    errors.push(`${location}: sem ficha no topo`);
    return null;
  }
  const missing = REQUIRED_FIELDS.filter((field) => !(field in fields));
  if (missing.length > 0) errors.push(`${location}: ficha sem ${missing.join(", ")}`);
  const decision = {
    path,
    location,
    markdown,
    number: Number(fields.numero),
    title: fields.titulo ?? "",
    date: fields.data ?? "",
    state: fields.estado,
    links: parseList(fields.links),
  };
  for (const [field, key] of Object.entries(NUMBER_LISTS)) decision[key] = parseList(fields[field]).map(Number);

  const numberInFileName = Number(basename(path).match(DECISION_FILE)[1]);
  if (decision.number !== numberInFileName) errors.push(`${location}: número da ficha (${fields.numero}) diferente do nome do arquivo`);
  if ("titulo" in fields && !decision.title) errors.push(`${location}: título vazio`);
  if ("data" in fields && !ISO_DATE.test(decision.date)) errors.push(`${location}: data "${decision.date}" fora do formato AAAA-MM-DD`);
  if ("estado" in fields && !(decision.state in STATE_LABELS)) errors.push(`${location}: estado desconhecido "${decision.state}"`);
  return decision;
}

function indexByNumber(decisions, errors) {
  const byNumber = new Map();
  for (const decision of decisions) {
    const previous = byNumber.get(decision.number);
    if (previous) errors.push(`número ${decision.number} repetido: ${previous.location} e ${decision.location}`);
    else byNumber.set(decision.number, decision);
  }
  return byNumber;
}

function checkRelations(byNumber, errors) {
  for (const decision of byNumber.values()) {
    for (const [field, reciprocal] of Object.entries(RECIPROCAL_FIELDS)) {
      for (const otherNumber of decision[field]) {
        const other = byNumber.get(otherNumber);
        const claim = `${decision.location}: ${RELATION_WORDING[field]} ${otherNumber}`;
        if (!other) errors.push(`${claim}, que não existe`);
        else if (!other[reciprocal].includes(decision.number)) errors.push(`${claim}, mas a ${otherNumber} não aponta de volta`);
      }
    }
  }
}

function freeTextOf(readme) {
  const heading = readme.match(INDEX_HEADING);
  return heading ? readme.slice(0, heading.index) : readme;
}

function checkFileLinks(path, markdown, root, errors) {
  for (const [, target] of markdown.replace(CODE_BLOCK, "").matchAll(MARKDOWN_FILE_LINK)) {
    if (!existsSync(join(dirname(path), target))) {
      errors.push(`${toPosix(relative(root, path))}: link para arquivo que não existe (${target})`);
    }
  }
}

function buildTable(folder, decisionsInside) {
  const hasSubfolders = decisionsInside.some((decision) => dirname(decision.path) !== folder);
  const header = hasSubfolders ? ["#", "Decisão", "Estado", "Pasta", "Data"] : ["#", "Decisão", "Estado", "Data"];
  const rows = decisionsInside.map((decision) => {
    const subfolder = toPosix(relative(folder, dirname(decision.path)));
    const folderCell = subfolder ? `[${subfolder}](${subfolder}/README.md)` : "";
    const cells = [`[${decision.number}](${toPosix(relative(folder, decision.path))})`, decision.title, STATE_LABELS[decision.state]];
    return hasSubfolders ? [...cells, folderCell, decision.date] : [...cells, decision.date];
  });
  const line = (cells) => `| ${cells.join(" | ")} |`;
  return [line(header), `|${header.map(() => "---").join("|")}|`, ...rows.map(line)].join("\n");
}

function writeIndex(folder, decisions) {
  const decisionsInside = decisions.filter((decision) => decision.path.startsWith(folder + sep));
  if (decisionsInside.length === 0) return false;
  const readme = join(folder, "README.md");
  const current = existsSync(readme) ? readText(readme) : `# ${basename(folder)}\n`;
  const heading = current.match(INDEX_HEADING);
  const freeText = heading ? current.slice(0, heading.index) : `${current.trimEnd()}\n\n`;
  writeFileSync(readme, `${freeText}## Índice\n\n${INDEX_NOTE}\n\n${buildTable(folder, decisionsInside)}\n`);
  return true;
}

function main() {
  const root = resolve(process.argv[2] ?? "decisoes");
  if (!existsSync(join(root, "README.md"))) throw new Error(`pasta de decisões sem README.md: ${root}`);

  const { decisionPaths, readmePaths, folders } = scanFolder(root);
  const errors = [];
  const decisions = decisionPaths
    .map((path) => loadDecision(path, root, errors))
    .filter(Boolean)
    .sort((first, second) => first.number - second.number);

  checkRelations(indexByNumber(decisions, errors), errors);
  for (const decision of decisions) checkFileLinks(decision.path, decision.markdown, root, errors);
  for (const readme of readmePaths) checkFileLinks(readme, freeTextOf(readText(readme)), root, errors);

  if (errors.length > 0) {
    console.error(errors.join("\n"));
    process.exitCode = 1;
    return;
  }
  const indexCount = folders.filter((folder) => writeIndex(folder, decisions)).length;
  console.log(`${decisions.length} decisões, ${indexCount} índices, 0 erros`);
}

try {
  main();
} catch (error) {
  console.error(`erro: ${error.message}`);
  process.exitCode = 2;
}
