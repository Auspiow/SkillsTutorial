import { spawnSync } from 'node:child_process';
import { cpSync, existsSync, mkdirSync, readFileSync, renameSync, rmSync, utimesSync } from 'node:fs';
import path from 'node:path';

const [mode, source, target] = process.argv.slice(2);
if (!['print', 'static'].includes(mode) || !source || !target) {
  console.error('Usage: node scripts/export.mjs <print|static> <source.md> <output>');
  process.exit(1);
}

// Detect reveal-md's swallowed errors without replacing the last good PDF.
const output = mode === 'print' ? `${target}.${process.pid}.tmp.pdf` : target;
try {
  mkdirSync(path.dirname(target), { recursive: true });
  const result = spawnSync(process.execPath, [
    'node_modules/reveal-md/bin/reveal-md.js', source, `--${mode}`, output
  ], {
    stdio: 'inherit',
    env: { ...process.env, ...(mode === 'print' ? { DEBUG: [process.env.DEBUG, 'reveal-md'].filter(Boolean).join(',') } : {}) }
  });
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error(`reveal-md failed (${result.signal || result.status})`);

  if (mode === 'print') {
    if (!existsSync(output) || readFileSync(output).subarray(0, 5).toString() !== '%PDF-') {
      throw new Error(`No valid PDF generated for ${source}; see the error above.`);
    }
    renameSync(output, target);
  } else {
    const index = path.join(target, 'index.html');
    if (!existsSync(index)) throw new Error(`No index.html generated for ${source}`);
    cpSync('assets/fonts', path.join(target, '_assets/assets/fonts'), { recursive: true });
    const now = new Date();
    utimesSync(index, now, now);
  }
} catch (error) {
  console.error(error.stack || error);
  process.exitCode = 1;
} finally {
  if (mode === 'print') rmSync(output, { force: true });
}
