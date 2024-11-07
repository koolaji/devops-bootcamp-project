const { Pool } = require('pg');
const redis = require('redis');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const redisClient = redis.createClient({
  url: process.env.REDIS_URL,
});

async function logProjects() {
  const { rows } = await pool.query('SELECT * FROM projects ORDER BY created_at DESC LIMIT 10');
  console.log('Recent projects:', rows);
}

setInterval(logProjects, 60000); // Log projects every minute

