import { useState } from 'react';
import { createPerson } from '../services/peopleApi';

function PersonForm() {
  const [formData, setFormData] = useState({
    first_name: '',
    middle_name: '',
    middle_name_override: false,
    last_name: '',
    ssn: '',
    street_address_1: '',
    street_address_2: '',
    city: '',
    state_abbreviation: '',
    zip_code: '',
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => {
      const newData = {
        ...prevData,
        [name]: value,
      };
      if (name === 'state_abbreviation') {
        newData.state_abbreviation = value.toUpperCase();
      }
      if (name === 'ssn') {
        const digits = value.replace(/\D/g, '');
        if (digits.length <= 3) {
          newData.ssn = digits;
        } else if (digits.length <= 5) {
          newData.ssn = `${digits.slice(0, 3)}-${digits.slice(3)}`;
        } else {
          newData.ssn = `${digits.slice(0, 3)}-${digits.slice(3, 5)}-${digits.slice(5, 9)}`;
        }
      }
      return newData;
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError('');
    setSuccess('');

    const dataToSend = {
      ...formData,
      middle_name_override: formData.middle_name === '' ? true : false
    };

    try {
      await createPerson(dataToSend);
      setSuccess('Person created successfully!');

      setFormData({
        first_name: '',
        middle_name: '',
        middle_name_override: false,
        last_name: '',
        ssn: '',
        street_address_1: '',
        street_address_2: '',
        city: '',
        state_abbreviation: '',
        zip_code: '',
      });
    } catch (err) {
      setError(err.message || 'Failed to create person');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto">
      <h2 className="text-2xl font-bold mb-6 text-gray-800">PII Data Collection Form</h2>
      <form onSubmit={handleSubmit} className="bg-white shadow-md rounded-lg p-6 md:p-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          <div>
            <label htmlFor="first_name" className="block text-sm font-medium text-gray-700 mb-1">
              First Name *
            </label>
            <input
              type="text"
              id="first_name"
              name="first_name"
              value={formData.first_name}
              onChange={handleChange}
              required
              maxLength={50}
              className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>

          <div>
            <label htmlFor="middle_name" className="block text-sm font-medium text-gray-700 mb-1">
              Middle Name
            </label>
            <input
              type="text"
              id="middle_name"
              name="middle_name"
              value={formData.middle_name}
              onChange={handleChange}
              maxLength={50}
              className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
        </div>

        <div className="mb-4">
          <label htmlFor="last_name" className="block text-sm font-medium text-gray-700 mb-1">
            Last Name *
          </label>
          <input
            type="text"
            id="last_name"
            name="last_name"
            value={formData.last_name}
            onChange={handleChange}
            required
            maxLength={50}
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div className="mb-4">
          <label htmlFor="ssn" className="block text-sm font-medium text-gray-700 mb-1">
            Social Security Number * (XXX-XX-XXXX)
          </label>
          <input
            type="text"
            id="ssn"
            name="ssn"
            value={formData.ssn}
            onChange={handleChange}
            required
            placeholder="XXX-XX-XXXX"
            pattern="\d{3}-\d{2}-\d{4}"
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div className="mb-4">
          <label htmlFor="street_address_1" className="block text-sm font-medium text-gray-700 mb-1">
            Street Address 1 *
          </label>
          <input
            type="text"
            id="street_address_1"
            name="street_address_1"
            value={formData.street_address_1}
            onChange={handleChange}
            required
            maxLength={255}
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div className="mb-4">
          <label htmlFor="street_address_2" className="block text-sm font-medium text-gray-700 mb-1">
            Street Address 2
          </label>
          <input
            type="text"
            id="street_address_2"
            name="street_address_2"
            value={formData.street_address_2}
            onChange={handleChange}
            maxLength={255}
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
          <div className="md:col-span-2">
            <label htmlFor="city" className="block text-sm font-medium text-gray-700 mb-1">
              City *
            </label>
            <input
              type="text"
              id="city"
              name="city"
              value={formData.city}
              onChange={handleChange}
              required
              maxLength={50}
              className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>

          <div>
            <label htmlFor="state_abbreviation" className="block text-sm font-medium text-gray-700 mb-1">
              State *
            </label>
            <input
              type="text"
              id="state_abbreviation"
              name="state_abbreviation"
              value={formData.state_abbreviation}
              onChange={handleChange}
              required
              maxLength={2}
              minLength={2}
              pattern="[A-Za-z]{2}"
              style={{ textTransform: 'uppercase' }}
              className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
        </div>

        <div className="mb-4">
          <label htmlFor="zip_code" className="block text-sm font-medium text-gray-700 mb-1">
            ZIP Code *
          </label>
          <input
            type="text"
            id="zip_code"
            name="zip_code"
            value={formData.zip_code}
            onChange={handleChange}
            required
            minLength={5}
            maxLength={10}
            pattern="\d{5}(-\d{4})?"
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        {error && (
          <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-md">
            {error}
          </div>
        )}
        {success && (
          <div className="mb-4 p-3 bg-green-50 border border-green-200 text-green-700 rounded-md">
            {success}
          </div>
        )}

        <button
          type="submit"
          disabled={isSubmitting}
          className="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
        >
          {isSubmitting ? 'Submitting...' : 'Submit'}
        </button>
      </form>
    </div>
  );
}

export default PersonForm;
