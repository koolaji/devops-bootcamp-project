import React from 'react';
import ReactDOM from 'react-dom';

function App() {
  const [apiResponse, setApiResponse] = React.useState('');

  React.useEffect(() => {
    fetch('/api')
      .then(res => res.json())
      .then(data => setApiResponse(data.message))
      .catch(() => setApiResponse('Error fetching from API'));
  }, []);

  return (
    <div>
      <h1>Hello from the React Frontend!</h1>
      <p><strong>Message from Backend:</strong> {apiResponse}</p>
    </div>
  );
}

ReactDOM.render(<App />, document.getElementById('root'));