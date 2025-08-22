import { prisma } from '../database'
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'
import type { User } from '@prisma/client'

// Read secrets from env
const JWT_SECRET: string = process.env.JWT_SECRET!
const JWT_EXPIRES_IN = '1h'
const SALT_ROUNDS = 10 // Number of rounds for bcrypt hashing

export type AuthResult = { token: string; user: User } // Result type for authentication methods

/** Register a new user, returning a signed JWT. */
const register = async (email: string, password: string) => {
  // 1. Check if user already exists
  const existing = await prisma.user.findUnique({ where: { email } })
  if (existing) {
    throw new Error('Email already in use')
  }

  // 2. Hash the password
  const passwordHash = await bcrypt.hash(password, SALT_ROUNDS)

  // 3. Create the user record
  const user = await prisma.user.create({
    data: { email, passwordHash }
  })

  // 4. Issue a JWT
  const token = jwt.sign(
    { userId: user.id, email: user.email },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRES_IN }
  )

  return { token, user }
}

/** Authenticate a user and return a JWT if credentials are valid. */
const login = async (email: string, password: string) => {
  // 1. Find the user
  const user = await prisma.user.findUnique({ where: { email } })
  if (!user) {
    throw new Error('Invalid credentials')
  }

  // 2. Compare password
  const valid = await bcrypt.compare(password, user.passwordHash)
  if (!valid) {
    throw new Error('Invalid credentials')
  }

  // 3. Issue a JWT
  const token = jwt.sign(
    { userId: user.id, email: user.email },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRES_IN }
  )

  return { token, user }
}

export const AuthService = { register, login } // Export the AuthService with methods for registration and login
