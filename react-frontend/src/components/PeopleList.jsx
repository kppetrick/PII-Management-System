import { useState, useEffect } from 'react';
import { fetchPeople } from '../services/peopleApi';

function PeopleList() {
    const [people, setPeople] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchData = async () => {
            try {
                const data = await fetchPeople();
                setPeople(data);
            } catch (err) {
                setError(err.message || 'Failed to fetch people');
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    return (
        <div className="max-w-4xl mx-auto">
            <h2 className="text-2xl font-bold mb-6 text-gray-800">People List</h2>
            {loading ? (
                <div className="text-center py-12">
                    <p className="text-gray-600">Loading...</p>
                </div>
            ) : error ? (
                <div className="bg-red-50 border border-red-200 text-red-700 p-4 rounded-md">
                    {error}
                </div>
            ) : people.length === 0 ? (
                <div className="text-center py-12">
                    <p className="text-gray-600">No people found.</p>
                </div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {people.map((person) => (
                        <div key={person.id} className="bg-white shadow-md rounded-lg p-6 hover:shadow-lg transition-shadow">
                            <div className="mb-4">
                                <h3 className="text-lg font-semibold text-gray-800 mb-1">
                                    {person.first_name} {person.middle_name} {person.last_name}
                                </h3>
                                <p className="text-sm text-gray-600">
                                    <span className="font-medium">SSN:</span> {person.ssn}
                                </p>
                            </div>
                            {person.address && (
                                <div className="border-t pt-4">
                                    <p className="text-sm font-medium text-gray-700 mb-2">Address:</p>
                                    <div className="text-sm text-gray-600 space-y-1">
                                        <p>
                                            {person.address.street_address_1}
                                            {person.address.street_address_2 && `, ${person.address.street_address_2}`}
                                        </p>
                                        <p>
                                            {person.address.city}, {person.address.state_abbreviation} {person.address.zip_code}
                                        </p>
                                    </div>
                                </div>
                            )}
                        </div>
                    ))}
                </div>
            )}
        </div>
    )
}

export default PeopleList;