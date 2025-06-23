import { useEffect, useState } from 'react';
import './App.css';
import './index.css';
import { Login } from './components/Login/Login';
import { Menu } from './components/Menu/Menu';
import { AssetTable } from './components/Dashboard/ViewAsset';
import { AssetDetails } from './components/Dashboard/ViewAssetDetails';
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { ReportsDetailPage } from './components/ReportsDetailpage/ReportsDetailPage';
import { ReportDetail } from './components/ReportsDetailpage/ReportDetail';
import DashboardContent from './components/Dashboard/DashboardContent';

const App = () => {
    const router = createBrowserRouter([
        {
            path: "/",
            element: <Login />,
        },
        {
            path: "/dashboard",
            element: <Menu />,
            children: [
                {
                    path: "/dashboard",
                    element: <DashboardContent />, // Add this line to render DashboardContent
                },
                {
                    path: "/dashboard/Assets/Details",
                    element: <AssetTable />,
                },
                {
                    path: "/dashboard/Assets/Details/:assetTagID",
                    element: <AssetDetails />,
                },
                {
                    path: "/dashboard/Reports/Detail",
                    element: <ReportsDetailPage />,
                },
                {
                    path: "/dashboard/Reports/Detail/:auditDateTime",
                    element: <ReportDetail />,
                },
            ]
        }
    ]);

    return <RouterProvider router={router} />;
}

export default App;
