import { useEffect, useState } from 'react'

import crystalLogo from './img/crystal.svg';
import reactLogo from './img/react.svg';

type VersionType = {
  crystal: string;
  athena: string;
}

function App() {
  const [count, setCount] = useState<number>(0);

  // Retrieve the versions.
  const [versions, setVersions] = useState<VersionType>({
    crystal: "",
    athena: ""
  });

  useEffect(() => {
    fetch("http://localhost:3000/versions")
      .then(res => res.json())
      .then(json => setVersions(json))
  }, []);

  return <>
    <div>
      <a href="https://www.crystal-lang.org" target="_blank">
        <img src={crystalLogo} className="logo" alt="Crystal logo" />
      </a>
      <a href="https://react.dev" target="_blank">
        <img src={reactLogo} className="logo react" alt="React logo" />
      </a>
    </div>
    <h1>Crystal + Athena + React</h1>
    <div className="card">
      <button onClick={() => setCount((count) => count + 1)}>
        count is {count}
      </button>
    </div>
    <p className="read-the-docs">
      Click on the Crystal and React logos to learn more
    </p>
    <p>
      Crystal <code>{versions.crystal}</code> - Athena Framework <code>{versions.athena}</code>
    </p>
  </>
}

export default App
