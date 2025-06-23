import React from 'react';

export function GlobalFilter({ filter, setFilter, darkMode }) {
    return (
        <div className="mb-4">
            <input
                type="text"
                value={filter || ''}
                onChange={e => setFilter(e.target.value)}
                placeholder="Search..."
                className={`shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
            />
        </div>
    );
}
