import { NextResponse } from 'next/server'

export async function GET(
    request: Request,
    { params }: { params: { id: string } }
) {
    try {
        const taskId = params.id

        if (!taskId) {
            return NextResponse.json(
                { error: 'Task ID is required' },
                { status: 400 }
            )
        }

        // Use fetch instead of ky for server-side requests
        const response = await fetch(`${process.env.COMASYNC_URL}/async_tasks/${taskId}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
        })

        if (!response.ok) {
            return NextResponse.json(
                { error: 'Task not found' },
                { status: response.status }
            )
        }

        const data = await response.json()
        return NextResponse.json(data)
    }
    catch (error) {
        console.error('Error fetching task:', error)
        return NextResponse.json(
            { error: 'Internal Server Error' },
            { status: 500 }
        )
    }
}