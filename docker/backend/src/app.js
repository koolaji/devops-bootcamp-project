const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    message: 'Hello from the backend API!',
    timestamp: new Date().toISOString()
  }));
});

const PORT = 5000;
server.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
});