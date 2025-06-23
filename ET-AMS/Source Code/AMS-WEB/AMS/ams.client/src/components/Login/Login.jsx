
import './Login.css';
import logo from '../../Images/EmergTechLogo.jpeg';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faGoogle, faFacebook } from '@fortawesome/free-brands-svg-icons';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

function Login() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate();

    const handleLogin = (e) => {
        e.preventDefault();

        console.log('Email:', email);
        console.log('Password:', password);

        if (!email || !password) {
            setError('Email and password are required');
            return;
        }

        // Simulated login (replace with real authentication logic)
        if (email === 'dev@emergtechsolutions.com' && password === '123') {
            console.log('Login successful');
            // Redirect to the dashboard
            navigate('/dashboard');
        } else {
            setError('Invalid email or password');
            console.log('Login failed');
        }
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-login shadow-custom-blue">
            <div className="bg-white p-8 md:p-16 rounded-3xl shadow-dark w-full max-w-md">
                <div className="text-center mb-8">
                    <img src={logo} alt="Emerge Tech" />
                </div>
                {error && <div className="text-red-500 mb-4">{error}</div>}
                <form onSubmit={handleLogin}>
                    <div className="mb-4">
                        <label htmlFor="email" className="block text-gray-700">
                            Email
                            <span className="text-red-500 ml-1">*</span>
                        </label>
                        <input
                            type="email"
                            id="email"
                            placeholder="Enter your email"
                            className="w-full px-3 py-2 border border-gray-300 rounded mt-1"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label htmlFor="password" className="block text-gray-700">
                            Password
                            <span className="text-red-500 ml-1">*</span>
                        </label>
                        <input
                            type="password"
                            id="password"
                            placeholder="Enter your password"
                            className="w-full px-3 py-2 border border-gray-300 rounded mt-1"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                    </div>
                    <div className="flex items-center justify-between mb-4">
                        <div>
                            <input type="checkbox" id="remind" className="mr-2" />
                            <label htmlFor="remind" className="text-gray-700">Remember me</label>
                        </div>
                        <a href="#" className="text-blue-500 hover:underline">Forgot Password?</a>
                    </div>
                    <button
                        type="submit"
                        className="w-full bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600"
                    >
                        LOGIN
                    </button>
                </form>
                <button className="w-full bg-gray-300 text-black py-2 rounded-lg mt-4 flex items-center justify-center hover:bg-gray-400">
                    <FontAwesomeIcon icon={faGoogle} className="w-5 h-5 mr-2" />
                    Login with Google
                </button>
                <button className="w-full bg-gray-300 text-black py-2 rounded-lg mt-4 flex items-center justify-center hover:bg-gray-400">
                    <FontAwesomeIcon icon={faFacebook} className="w-5 h-5 mr-2" />
                    Login with Facebook
                </button>
            </div>
        </div>
    );
}

export { Login };

