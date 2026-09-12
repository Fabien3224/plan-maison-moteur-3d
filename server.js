const express = require('express');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const { spawn } = require('child_process');

const app = express();
const PORT = process.env.PORT || 3000;
const ROOT = __dirname;
const RENDER_DIR = path.join(ROOT, 'renders');
const JOB_DIR = path.join(ROOT, 'jobs');
const BLENDER = process.env.BLENDER_BIN || 'blender';
fs.mkdirSync(RENDER_DIR, { recursive: true });
fs.mkdirSync(JOB_DIR, { recursive: true });

app.use(express.json({ limit: '5mb' }));
app.use('/renders', express.static(RENDER_DIR, { maxAge: '1h' }));
app.use(express.static(path.join(ROOT, 'public')));

app.get('/api/health', (req, res) => res.json({ ok: true, engine: 'Blender', status: 'ready' }));

app.post('/api/render3d', async (req, res) => {
  const payload = req.body || {};
  if (!payload.plan || !payload.plan.terrain || !Array.isArray(payload.plan.rooms)) {
    return res.status(400).json({ error: 'Payload de plan invalide.' });
  }
  const id = crypto.randomUUID();
  const input = path.join(JOB_DIR, `${id}.json`);
  const output = path.join(RENDER_DIR, `${id}.png`);
  fs.writeFileSync(input, JSON.stringify(payload, null, 2), 'utf8');

  const script = path.join(ROOT, 'blender', 'render_plan.py');
  const args = ['-b', '-P', script, '--', '--input', input, '--output', output];
  const child = spawn(BLENDER, args, { cwd: ROOT });
  let stderr = '';
  child.stderr.on('data', d => { stderr += d.toString(); if (stderr.length > 12000) stderr = stderr.slice(-12000); });
  child.stdout.on('data', () => {});
  child.on('error', err => {
    try { fs.unlinkSync(input); } catch {}
    res.status(503).json({ error: 'Moteur Blender indisponible.', detail: err.message });
  });
  child.on('close', code => {
    try { fs.unlinkSync(input); } catch {}
    if (res.headersSent) return;
    if (code !== 0 || !fs.existsSync(output)) {
      return res.status(502).json({ error: 'Le rendu 3D a échoué.', detail: stderr.slice(-4000) });
    }
    const base = `${req.protocol}://${req.get('host')}`;
    res.json({ ok: true, image_url: `${base}/renders/${id}.png`, engine: 'Blender', job_id: id });
  });
});

app.get('*', (req, res) => res.sendFile(path.join(ROOT, 'public', 'index.html')));
app.listen(PORT, () => console.log(`PLAN MAISON 3D server listening on ${PORT}`));
