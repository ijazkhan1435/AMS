import React, { useState } from 'react';
import { FaEye, FaEyeSlash } from 'react-icons/fa';

function UserForm({ darkMode }) {
    const [passwordVisible, setPasswordVisible] = useState(false);

    return (
        <div className={`p-8 ${darkMode ? 'bg-gray-900 text-white' : 'bg-gray-100 text-black'}`}>
            {/* User ID Field */}
            <div className="mb-4">
                <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="userId">
                    User ID
                </label>
                <input
                    className={`shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
                    id="userId"
                    type="text"
                    placeholder="User ID"
                />
            </div>

            {/* User Name Field */}
            <div className="mb-4">
                <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="userName">
                    User Name
                </label>
                <input
                    className={`shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
                    id="userName"
                    type="text"
                    placeholder="User Name"
                />
            </div>

            {/* New Password Field */}
            <div className="mb-4 relative">
                <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="newPassword">
                    New Password
                </label>
                <div className="relative">
                    <input
                        className={`shadow appearance-none border rounded w-full py-2 px-3 leading-tight pr-10 focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
                        id="newPassword"
                        type={passwordVisible ? 'text' : 'password'}
                        placeholder="New Password"
                    />
                    <div
                        className="absolute inset-y-0 right-0 pr-3 flex items-center cursor-pointer"
                        onClick={() => setPasswordVisible(!passwordVisible)}
                    >
                        {passwordVisible ? (
                            <FaEyeSlash className={`h-5 w-5 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} />
                        ) : (
                            <FaEye className={`h-5 w-5 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} />
                        )}
                    </div>
                </div>
            </div>

            {/* Buttons */}
            <div className="flex items-center justify-center mt-6 space-x-4">
                <button
                    className={`bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-blue-600' : 'bg-blue-500'}`}
                    type="button"
                >
                    Save
                </button>
                <button
                    className={`bg-red-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-500' : 'bg-gray-500'}`}
                    type="button"
                >
                    Reset
                </button>
            </div>
        </div>
    );
}

export default UserForm;
