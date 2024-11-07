const express = require('express');
const { Pool } = require('pg');
const { Client } = require('@elastic/elasticsearch');

const app = express();
const port = 5000;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const esClient = new Client({
  node: process.env.ELASTICSEARCH_URL,
});

app.get('/projects', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM projects');
    res.json(result.rows);
    
    // Log the request to Elasticsearch
    await esClient.index({
      index: 'logs',
      body: {
        timestamp: new Date(),
        message: 'Fetched projects',
      },
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Backend API is running on port ${port}`);
});

