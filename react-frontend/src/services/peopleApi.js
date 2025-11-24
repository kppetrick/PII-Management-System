const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000';

export const fetchPeople = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/api/people`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    throw new Error('Failed to fetch people: ' + error.message);
  }
};

export const createPerson = async (personData) => {
  try {
    const response = await fetch(`${API_BASE_URL}/api/people`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ person: personData }),
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || `HTTP error! status: ${response.status}`);
    }

    return data;
  } catch (error) {
    throw new Error('Failed to create person: ' + error.message);
  }
};
