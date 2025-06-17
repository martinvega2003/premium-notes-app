import React, { createContext, useState, useEffect } from 'react'
import type { ReactNode } from 'react';

// 1. Define the shape of context values
interface ThemeContextType {
  darkMode: boolean
  setDarkMode: React.Dispatch<React.SetStateAction<boolean>>
}

// 2. Create the context with a default value (will be overridden by the provider)
export const ThemeContext = createContext<ThemeContextType>({ // Between <> specifies the type of context (values and types)
  darkMode: false,
  setDarkMode: () => {}  // no-op default
})

// 3. Define props type for the provider
interface ThemeProviderProps {
  children: ReactNode
}

// 4. The provider component
export const ThemeProvider: React.FC<ThemeProviderProps> = ({ children }) => { // React.FC is a type for functional components. Between <> specifies the type of props
  const [darkMode, setDarkMode] = useState<boolean>(false)

  // On mount, read from localStorage
  useEffect(() => {
    const stored = localStorage.getItem('darkMode')
    setDarkMode(stored === 'true')
  }, [])

  // Whenever darkMode changes, update DOM and localStorage
  useEffect(() => {
    document.documentElement.dataset.theme = darkMode ? 'dark' : 'light'
    localStorage.setItem('darkMode', String(darkMode))
  }, [darkMode])

  return (
    <ThemeContext.Provider value={{ darkMode, setDarkMode }}>
      {children}
    </ThemeContext.Provider>
  )
}