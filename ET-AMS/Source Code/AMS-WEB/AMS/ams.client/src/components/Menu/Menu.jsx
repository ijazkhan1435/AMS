import React, { useState, useEffect } from 'react';
import { useNavigate, Outlet } from 'react-router-dom';
import '../../index.css';
import '@fortawesome/fontawesome-free/css/all.min.css';
import { FaUser, FaCog, FaSignOutAlt, FaBell, FaUserCircle } from 'react-icons/fa';
import { FiSun, FiMoon, FiLogOut, FiSearch } from 'react-icons/fi'; // Importing outline icons from react-icons

import DashboardContent from '../Dashboard/DashboardContent'; // Assuming this exists

import '../../index.css'; 
import { AssetTable } from '../Dashboard/ViewAsset';
import { ReportsDetailPage } from '../ReportsDetailpage/ReportsDetailPage';

import CreateUser from '../Uac/CreateUser';
import CreateUserRole from '../Uac/CreateUserRole';
import UserRolePermission from '../Uac/UserRolePermission';
import ChangePassword from '../Uac/ChangePassword';

import ETIcon from '../../assets/icons/et-icon-2.svg';
import dashboardIcon from '../../assets/icons/dashboard.jpg';
import inventoryIcon from '../../assets/icons/Inventory.svg';
import reportIcon from '../../assets/icons/report.svg';
import poIcon from '../../assets/icons/doc-2.svg';
import analytics from '../../assets/icons/analytics.svg';
import userIcon from '../../assets/icons/user.svg';
import pickIcon from '../../assets/icons/picking.svg';
import cartonIcon from '../../assets/icons/carton add.svg';

function Menu() {
    const [darkMode, setDarkMode] = useState(false);
    const [showNotifications, setShowNotifications] = useState(false);
    const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);
    const [isGrnDropdownOpen, setIsGrnDropdownOpen] = useState(false);
    const [isUacDropdownOpen, setIsUacDropdownOpen] = useState(false);
    const [isInventoryDropdownOpen, setIsInventoryDropdownOpen] = useState(false);
    const [isPODropdownOpen, setIsPODropdownOpen] = useState(false);
    const [isPickListDropdownOpen, setIsPickListDropdownOpen] = useState(false);
    const [isProfileOpen, setIsProfileOpen] = useState(false);
    const navigate = useNavigate();
    const [activeComponent, setActiveComponent] = useState('Dashboard');


    useEffect(() => {
        const handleResize = () => {
            setIsSidebarCollapsed(window.innerWidth < 768);
        };

        handleResize();
        window.addEventListener('resize', handleResize);

        return () => window.removeEventListener('resize', handleResize);
    }, []);

    const toggleDarkMode = () => setDarkMode(!darkMode);
    const toggleNotifications = () => setShowNotifications(!showNotifications);
    const toggleSidebar = () => setIsSidebarCollapsed(!isSidebarCollapsed);

    const handleClickOutside = (event) => {
        if (!event.target.closest('.notification-button')) {
            setShowNotifications(false);
        }
        if (!event.target.closest('#Image_Profile')) {
            setIsProfileOpen(false);
        }
        if (!event.target.closest('.uac-button')) {
            setIsUacDropdownOpen(false);
        }
        if (!event.target.closest('.inventory-button')) {
            setIsInventoryDropdownOpen(false);
        }
        if (!event.target.closest('.grn-button')) {
            setIsGrnDropdownOpen(false);
        }
        if (!event.target.closest('.po-button')) {
            setIsPODropdownOpen(false);
        }
        if (!event.target.closest('.picklist-button')) {
            setIsPickListDropdownOpen(false);
        }
    };

    useEffect(() => {
        document.addEventListener('click', handleClickOutside);
        return () => {
            document.removeEventListener('click', handleClickOutside);
        };
    }, []);

    const handleGrnClick = () => {
        setIsGrnDropdownOpen(!isGrnDropdownOpen);
        setIsUacDropdownOpen(false);
        setIsInventoryDropdownOpen(false);
        setShowNotifications(false);
        setIsPODropdownOpen(false);
        setIsPickListDropdownOpen(false);
    };

    const handleUacClick = () => {
        setIsUacDropdownOpen(!isUacDropdownOpen);
        setIsGrnDropdownOpen(false);
        setIsInventoryDropdownOpen(false);
        setShowNotifications(false);
        setIsPODropdownOpen(false);
        setIsPickListDropdownOpen(false);
    };

    const handleInventoryClick = () => {
        setIsInventoryDropdownOpen(!isInventoryDropdownOpen);
        setIsGrnDropdownOpen(false);
        setIsUacDropdownOpen(false);
        setShowNotifications(false);
        setIsPODropdownOpen(false);
        setIsPickListDropdownOpen(false);
    };

    const handlePOClick = () => {
        setIsPODropdownOpen(!isPODropdownOpen);
        setIsInventoryDropdownOpen(false);
        setIsGrnDropdownOpen(false);
        setIsUacDropdownOpen(false);
        setShowNotifications(false);
        setIsPickListDropdownOpen(false);
    };

    const handlePickListClick = () => {
        setIsPickListDropdownOpen(!isPickListDropdownOpen);
        setIsInventoryDropdownOpen(false);
        setIsGrnDropdownOpen(false);
        setIsUacDropdownOpen(false);
        setShowNotifications(false);
        setIsPODropdownOpen(false);
    };

    const handleSignOut = () => {
        // Handle sign-out logic here (e.g., clearing auth tokens, etc.)
        navigate('/'); // Redirect to login page
    };

        const renderContent = () => {
            switch (activeComponent) {
                case 'Dashboard':
                    return <DashboardContent darkMode={darkMode} />;
                case 'Asset Details': // Update the case name
                    return <AssetTable darkMode={darkMode} />; // Render ViewAsset component
                case 'Reports Detail Page':
                    return <ReportsDetailPage darkMode={darkMode} />;
                case 'ViewAssetDetails':
                    return <AssetDetails darkMode={darkMode} />;
                case 'ReportDetail':
                    return <ReportDetail darkMode={darkMode} />;

                //case 'Create User':
                //    return <CreateUser darkMode={darkMode} />;
                //case 'Change Password':
                //    return <ChangePassword darkMode={darkMode} />;
                //case 'Create User Role':
                //    return <CreateUserRole darkMode={darkMode} />;
                //case 'User Role Permission':
                //    return <UserRolePermission darkMode={darkMode} />;
                default:
                    return <DashboardContent darkMode={darkMode} />;
            }
        };

    return (
        <div className="h-screen flex flex-col">


            <div className="flex flex-1 overflow-hidden">
                {/* Sidebar */}
                <div className={`sidebar flex flex-col h-full border-r ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-300'} ${isSidebarCollapsed ? 'w-20' : 'custom-width'}`}>
                    {/* Sidebar */}
                    {/*<div*/}
                    {/*    className={`sidebar flex flex-col justify-between h-full border-r ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-300'} ${isSidebarCollapsed ? 'w-20' : ''} ${!isSidebarCollapsed ? 'custom-width' : ''}`}*/}
                    {/*    style={{ flex: 'none' }}*/}
                    {/*>*/}
                    <div>
                        <div className="flex justify-between p-2">
                            <a href="#warehouse" className="flex items-center">
                                <h1 className={`text-2xl font-bold flex items-center ${darkMode ? 'text-white' : 'text-black'}`}>
                                    <img src={ETIcon} alt="ET Icon" className="w-6 h-6 mr-2" />
                                    <span className={`${isSidebarCollapsed ? 'hidden' : ''} bg-clip-text text-transparent bg-gradient-to-r from-blue-500 to-blue-800`}>
                                        AMS
                                    </span>
                                </h1>
                            </a>
                        </div>
                        <ul>
                            <li className="mb-2">
                                <button
                                    onClick={() => navigate('/dashboard')}
                                    className={`flex items-center p-2 ${darkMode ? 'text-white' : 'text-black'} hover:bg-gradient-to-r from-blue-300 to-blue-100  w-full text-left`}
                                >
                                    {/* <i className="fas fa-tachometer-alt mr-2"></i>*/}
                                    <img src={analytics} alt="dashboard Icon" className="w-8 h-8 mr-2" />

                                    <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm`}>Dashboard</span>
                                </button>
                            </li>
                         
                            <li className="mb-2">
                                <button
                                    onClick={handleInventoryClick}
                                    className="inventory-button flex ${darkMode ? 'text-white' : 'text-black'} items-center p-2 hover:bg-gradient-to-r from-blue-300 to-blue-100 w-full text-left justify-between"
                                >
                                    <div className="flex items-center ${darkMode ? 'text-white' : 'text-black'}">
                                        <img src={cartonIcon} alt="inventory Icon" className="w-8 h-7 mr-2" />
                                        <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>View Asset</span>
                                    </div>
                                    <i className={`fas ${isInventoryDropdownOpen ? 'fa-chevron-up' : 'fa-chevron-down'} ml-2 text-sm ${darkMode ? 'text-white' : 'text-black'}`}></i>
                                </button>
                                {isInventoryDropdownOpen && (
                                    <ul className="flex flex-row pl-6 space-x-2">
                                        <li className="flex-shrink-0">
                                            <button
                                                onClick={() => navigate('/dashboard/Assets/Details')}/*setActiveComponent('Asset Details')}*/
                                                className="flex ${darkMode ? 'text-white' : 'text-black'} items-center p-2 hover:text-[#6abded] to-blue-100 text-left"
                                            >
                                                <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Assets Details</span>


                                            </button>
                                            {/*<button*/}
                                            {/*    onClick={() => navigate('/inventory/item-definition')}*/}
                                            {/*    className="flex ${darkMode ? 'text-white' : 'text-black'} items-center p-2  text-left"*/}
                                            {/*>*/}
                                            {/*    <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Item Definition</span>*/}


                                            {/*</button>*/}

                                        </li>
                                    </ul>
                                )}
                            </li>
                            <li className="mb-2">
                                <button
                                    onClick={handlePOClick}
                                    className="po-button flex ${darkMode ? 'text-white' : 'text-black'} items-center p-2 hover:bg-gradient-to-r from-blue-300 to-blue-100  w-full text-left justify-between"
                                >
                                    {/*<i className="fas fa-file mr-2"></i>*/}
                                    <img src={poIcon} alt="po Icon" className="w-8 h-7 mr-2" />
                                    <div className="flex items-center">
                                        <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Audit Report</span>
                                    </div>
                                    <i className={`fas ${isPODropdownOpen ? 'fa-chevron-up' : 'fa-chevron-down'} ml-2 text-sm ${darkMode ? 'text-white' : 'text-black'}`}></i>
                                </button>

                                {isPODropdownOpen && (
                                    <ul className="flex flex-col pl-6 space-y-2">
                                        <li className="flex-shrink-0">
                                            <button
                                                onClick={() => navigate('/dashboard/Reports/Detail')}
                                                className="flex items-center p-2 hover:text-[#6abded] text-left"
                                            >
                                                <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Audit Details</span>
                                            </button>
                                        </li>
                                        {/*<li className="flex-shrink-0">*/}
                                        {/*    <button*/}
                                        {/*        onClick={() => navigate('/create-purchase-order')}*/}
                                        {/*        className="flex items-center p-2 hover:text-[#6abded] text-left"*/}
                                        {/*    >*/}
                                        {/*        <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Create PO</span>*/}
                                        {/*    </button>*/}
                                        {/*</li>*/}
                                    </ul>

                                )}
                            </li>
                           
                            <li className="mb-2">
                                <button
                                    onClick={handleUacClick}
                                    className="uac-button flex items-center p-2 hover:bg-gradient-to-r from-blue-300 to-blue-100  w-full text-left justify-between"
                                >
                                    <div className="flex items-center">
                                        <img src={userIcon} alt="user Icon" className="w-8 h-5 mr-2" />
                                        <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>UAC</span>
                                    </div>
                                    <i className={`fas ${isUacDropdownOpen ? 'fa-chevron-up' : 'fa-chevron-down'} ml-2 text-sm ${darkMode ? 'text-white' : 'text-black'}`}></i>
                                </button>
                                {isUacDropdownOpen && (
                                    <ul className="flex flex-col pl-6 space-y-2">
                                        <li className="flex-shrink-0">
                                            <button
                                                onClick={() => navigate('/uac/create-user')}
                                                className="flex items-center p-2 rounded-lg hover:text-[#6abded] text-left"
                                            >
                                                <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Create User</span>
                                            </button>
                                        </li>
                                        <li className="flex-shrink-0">
                                            <button
                                                onClick={() => navigate('/uac/create-role')}
                                                className="flex items-center p-2 rounded-lg hover:text-[#6abded] text-left"
                                            >
                                                <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Create Role</span>
                                            </button>
                                        </li>
                                        <li className="flex-shrink-0">
                                            <button
                                                onClick={() => navigate('/uac/user-role-permissions')}
                                                className="flex items-center p-2 rounded-lg hover:text-[#6abded] text-left"
                                            >
                                                <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>User Permissions</span>
                                            </button>
                                        </li>
                                        <li className="flex-shrink-0">
                                            <button
                                                onClick={() => navigate('/uac/change-password')}
                                                className="flex items-center p-2 rounded-lg hover:text-[#6abded] text-left"
                                            >
                                                <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Change Password</span>
                                            </button>
                                        </li>
                                    </ul>

                                )}
                            </li>
                        </ul>
                    </div>
                    <div className="flex flex-col w-full mt-auto">
                        <button
                            onClick={toggleDarkMode}
                            className="w-full flex items-center justify-start p-2 hover:bg-gradient-to-r from-blue-300 to-blue-100 text-left"
                        >
                            <FiSun className={`mr-2 text-[#6abded] ${darkMode ? 'hidden' : 'block'} ${darkMode ? 'text-white' : 'text-black'}`} />
                            <FiMoon className={`mr-2 text-[#6abded] ${darkMode ? 'block' : 'hidden'}`} />
                            <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>
                                {darkMode ? 'Light Mode' : 'Dark Mode'}
                            </span>
                        </button>
                        <button
                            onClick={handleSignOut}
                            className="w-full flex items-center justify-start p-2 hover:bg-gradient-to-r from-blue-300 to-blue-100 text-left"
                        >
                            <FiLogOut className="mr-2 text-[#6abded]" />
                            <span className={`${isSidebarCollapsed ? 'hidden' : ''} text-sm ${darkMode ? 'text-white' : 'text-black'}`}>Sign Out</span>
                        </button>
                    </div>


                </div>
                {/*</div>*/}

                {/* Main Content */}
                <div className="flex flex-col flex-1">
                    {/* App Bar */}
                    <div className={`flex items-center p-4 border-b border-r-2 ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-300'} relative z-10`} style={{ width: '100%', borderColor: darkMode ? '#4A5568' : '#D1D5DB' }}>
                        <div className="flex items-center">
                            <FiSearch className={`text-lg mr-2 ${darkMode ? 'text-white' : 'text-black'}`} />
                            <input
                                type="text"
                                placeholder="Search..."
                                className={`p-2 rounded-md outline-none ${darkMode ? 'bg-gray-700 text-white' : 'bg-gray-200 text-black'}`}
                                style={{ marginLeft: isSidebarCollapsed ? '0.01rem' : '0.01rem' }}
                            />
                        </div>
                        <div className="ml-auto flex items-center space-x-4">
                            <button onClick={toggleNotifications} className="relative p-2 rounded-full hover:bg-gray-200 dark:hover:bg-gray-700">
                                <FaBell className={`text-lg ${darkMode ? 'text-white' : 'text-black'}`} />
                                {showNotifications && <span className="absolute top-0 right-0 h-2 w-2 bg-red-600 rounded-full"></span>}
                            </button>
                            <div onClick={() => setIsProfileOpen(!isProfileOpen)} id="Image_Profile" className="relative p-2 cursor-pointer">
                                <FaUserCircle className={`text-2xl ${darkMode ? 'text-white' : 'text-black'}`} />
                                {isProfileOpen && (
                                    <div className="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-700 shadow-md rounded-lg p-2">
                                        <button onClick={handleSignOut} className="w-full text-left p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600">
                                            <FiLogOut className="mr-2" /> Sign Out
                                        </button>
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>


                    {/* Content */}
                    <div className="flex-1 p-4 overflow-auto">
                        <Outlet />
                        {/*{renderContent()}*/}
                    </div>
                </div>

            </div>
        </div>
    );
}

export { Menu };

