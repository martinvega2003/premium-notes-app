import { Request, Response, NextFunction } from 'express'

// A very basic error handler stub
export function errorMiddleware(
  err: any,
  _req: Request,
  res: Response,
  _next: NextFunction
) {
  console.error('Unhandled error:', err)
  res.status(500).json({ error: 'Internal Server Error' })
}