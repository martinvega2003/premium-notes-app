import React, { useContext } from 'react'
import { ThemeContext } from '../context/ThemeContext'

const AuthPage = () => {
  const { darkMode, setDarkMode } = useContext(ThemeContext)

  return (
    <div className="bg-gray-200 dark:bg-gray-800 dark:text-white w-full h-screen flex flex-col gap-2 justify-center items-center">
      <h1 className="text-3xl font-bold">Hello, Premium Notes App!</h1>
      <p className="text-lg mt-4">This is a simple React app with Tailwind CSS.</p>
      <p className="text-lg mt-4">Enjoy building your notes!</p>
      <button
        className="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        onClick={() => setDarkMode(!darkMode)}
      >
        Toggle Dark Mode
      </button>
      <p className="mt-4">
        Dark mode is currently {darkMode ? 'enabled' : 'disabled'}.
      </p>
    </div>
  )
}

export default AuthPage