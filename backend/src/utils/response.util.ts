// utils/response.util.ts
import { HttpStatus } from '@nestjs/common';

export function customResponse(response: any, message: string, statusCode: number, data?: any, accessToken?: string, totalLength?: number) {
    return response.status(statusCode).json({
        statusCode: statusCode,
        message,
        data,
        accessToken,
        totalLength
    });
}

export function okResponse(message: string, data?: any) {
    return {
        statusCode: HttpStatus.OK,
        message,
        data,
    };
}

export function errorResponse(message: string, statusCode: number, data?: any) {
    return {
        statusCode,
        message,
        data,
    };
}
