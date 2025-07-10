import enqueue from '@/utils/enqueue'
import { NextResponse } from 'next/server'

export async function POST(
    request: Request,
    { params }: { params: { id: string } }
) {

    try {
        const body = await request.json()

        await enqueue('/tasks/trigger', {
            id: body.id,
        })
        
        return NextResponse.json(
            { message: 'Success' },
            { status: 200 }
        )
    }
    catch (error) {
        return NextResponse.json(
            { error: 'Internal Server Error' },
            { status: 500 }
        )
    }
}