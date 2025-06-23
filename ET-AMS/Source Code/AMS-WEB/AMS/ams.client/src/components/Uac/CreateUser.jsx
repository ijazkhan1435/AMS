import React, { useState, useEffect } from 'react';
import { useTable, useSortBy, usePagination, useFilters, useGlobalFilter } from 'react-table';
import { GlobalFilter } from './GlobalFilter';

function CreateUser({ darkMode }) {
    const [showPopup, setShowPopup] = useState(false);

    useEffect(() => {
        document.body.classList.toggle('dark', darkMode);
    }, [darkMode]);

    const data = React.useMemo(
        () => [
            { SerialNo: 1, USERNAME: 'JohnDoe', CreatedBy: 'Admin', RollsID: '123', Password: '******', Activation: false },
            { SerialNo: 2, USERNAME: 'JaneDoe', CreatedBy: 'Admin', RollsID: '124', Password: '******', Activation: true },
            // Add more data as needed...
        ],
        []
    );

    const columns = React.useMemo(
        () => [
            { Header: 'SerialNo', accessor: 'SerialNo' },
            { Header: 'USERNAME', accessor: 'USERNAME' },
            { Header: 'Created By', accessor: 'CreatedBy' },
            { Header: 'RollsID', accessor: 'RollsID' },
            { Header: 'Password', accessor: 'Password' },
            {
                Header: 'Activation',
                accessor: 'Activation',
                Cell: ({ value }) => <input type="checkbox" checked={value} readOnly />,
            },
        ],
        []
    );

    const {
        getTableProps,
        getTableBodyProps,
        headerGroups,
        page,
        prepareRow,
        state: { pageIndex, pageSize, globalFilter },
        canPreviousPage,
        canNextPage,
        pageOptions,
        gotoPage,
        nextPage,
        previousPage,
        setPageSize,
        setGlobalFilter,
    } = useTable(
        { columns, data, initialState: { pageIndex: 0 } },
        useFilters,
        useGlobalFilter,
        useSortBy,
        usePagination
    );

    const handleSubmit = () => {
        // Logic to save the record goes here

        // Show the popup message
        setShowPopup(true);

        // Hide the popup message after a few seconds
        setTimeout(() => setShowPopup(false), 3000);
    };

    return (
        <div className={`p-8 ${darkMode ? 'bg-gray-900 text-white' : 'bg-gray-100 text-black'}`}>
            <h1 className="text-2xl font-bold mb-4">Create User</h1>

            <form className={`shadow-md rounded px-8 pt-6 pb-8 mb-4 ${darkMode ? 'bg-gray-800' : 'bg-white'}`}>
                <div className="mb-4">
                    <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="name">
                        Name
                    </label>
                    <input
                        className={`shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
                        id="name"
                        type="text"
                        placeholder="Name"
                    />
                </div>
                <div className="mb-4">
                    <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="password">
                        Password
                    </label>
                    <input
                        className={`shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
                        id="password"
                        type="password"
                        placeholder="Password"
                    />
                </div>
                <div className="mb-6">
                    <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="roles">
                        Roles
                    </label>
                    <div className="relative">
                        <select
                            className={`block appearance-none w-full px-4 py-2 pr-8 rounded shadow leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-400'}`}
                            id="roles"
                        >
                            <option>Admin</option>
                            <option>User</option>
                            <option>Guest</option>
                        </select>
                        <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                            <svg className="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                                <path d="M5.3 7.7a1 1 0 011.4 0L10 10.586l3.3-2.886a1 1 0 111.4 1.428l-4 3.5a1 1 0 01-1.4 0l-4-3.5a1 1 0 010-1.428z" />
                            </svg>
                        </div>
                    </div>
                </div>
                <div className="mb-4">
                    <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="activation">
                        Activate/Deactivate
                    </label>
                    <input
                        type="checkbox"
                        id="activation"
                        className={`leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
                    />
                </div>
                <div className="flex items-center justify-between">
                    <button
                        className={`bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-blue-600' : 'bg-blue-500'}`}
                        type="button"
                        onClick={handleSubmit}
                    >
                        Submit
                    </button>
                </div>
            </form>

            {showPopup && (
                <div className={`fixed top-0 right-0 m-4 p-4 bg-green-500 text-white rounded ${darkMode ? 'bg-green-700' : 'bg-green-500'}`}>
                    Your record has been successfully saved!
                </div>
            )}

            <GlobalFilter filter={globalFilter} setFilter={setGlobalFilter} darkMode={darkMode} />

            <table {...getTableProps()} className={`min-w-full ${darkMode ? 'bg-gray-800 text-gray-300' : 'bg-white text-gray-900'} border border-gray-200`}>
                <thead>
                    {headerGroups.map(headerGroup => (
                        <tr {...headerGroup.getHeaderGroupProps()} key={headerGroup.id}>
                            {headerGroup.headers.map(column => (
                                <th
                                    {...column.getHeaderProps(column.getSortByToggleProps())}
                                    key={column.id}
                                    className={`py-2 px-4 border-b ${darkMode ? 'border-gray-600 bg-gray-700 text-gray-300' : 'border-gray-200 bg-gray-100 text-gray-600'} text-left font-semibold`}
                                >
                                    {column.render('Header')}
                                    <span>
                                        {column.isSorted ? (column.isSortedDesc ? ' 🔽' : ' 🔼') : ''}
                                    </span>
                                </th>
                            ))}
                        </tr>
                    ))}
                </thead>
                <tbody {...getTableBodyProps()}>
                    {page.map(row => {
                        prepareRow(row);
                        return (
                            <tr {...row.getRowProps()} key={row.id} className={`${darkMode ? 'bg-gray-800 text-gray-300' : 'hover:bg-gray-50'}`}>
                                {row.cells.map(cell => (
                                    <td
                                        {...cell.getCellProps()}
                                        key={cell.column.id}
                                        className={`py-2 px-4 border-b ${darkMode ? 'border-gray-600' : 'border-gray-200'}`}
                                    >
                                        {cell.render('Cell')}
                                    </td>
                                ))}
                            </tr>
                        );
                    })}
                </tbody>
            </table>

            <div className="flex justify-between items-center mt-4">
                <button
                    onClick={() => gotoPage(0)}
                    disabled={!canPreviousPage}
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                >
                    {'<<'}
                </button>
                <button
                    onClick={() => previousPage()}
                    disabled={!canPreviousPage}
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                >
                    {'<'}
                </button>
                <span>
                    Page{' '}
                    <strong>
                        {pageIndex + 1} of {pageOptions.length}
                    </strong>{' '}
                </span>
                <button
                    onClick={() => nextPage()}
                    disabled={!canNextPage}
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                >
                    {'>'}
                </button>
                <button
                    onClick={() => gotoPage(pageOptions.length - 1)}
                    disabled={!canNextPage}
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                >
                    {'>>'}
                </button>
                <select
                    value={pageSize}
                    onChange={e => setPageSize(Number(e.target.value))}
                    className={`border rounded py-2 px-3 ${darkMode ? 'border-gray-600 bg-gray-700 text-white' : 'border-gray-300 bg-white text-black'}`}
                >
                    {[10, 20, 30, 40, 50].map(size => (
                        <option key={size} value={size}>
                            Show {size}
                        </option>
                    ))}
                </select>
            </div>
        </div>
    );
}

export default CreateUser;
