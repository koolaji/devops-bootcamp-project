console.log("Worker process started.");

function doWork() {
    console.log(`[${new Date().toISOString()}] Worker is processing a task...`);
    // In a real application, this would pull jobs from a queue (e.g., Redis)
}

// Simulate work every 10 seconds
setInterval(doWork, 10000);