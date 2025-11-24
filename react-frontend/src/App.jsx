import './App.css';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import PersonForm from './components/PersonForm';
import PeopleList from './components/PeopleList';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-50">
        <nav className="bg-blue-600 text-white shadow-md">
          <div className="container mx-auto px-4 py-3">
            <div className="flex space-x-4">
              <Link to="/" className="hover:text-blue-200 transition-colors">Add Person</Link>
              <Link to="/people" className="hover:text-blue-200 transition-colors">View People</Link>
            </div>
          </div>
        </nav>
        <div className="container mx-auto px-4 py-8">
          <Routes>
            <Route path="/" element={<PersonForm />} />
            <Route path="/people" element={<PeopleList />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;