import { GetUser } from './../decorators/get-user.decorator';
import { Controller, Get, Post, Body, Patch, Param, Delete, Res, HttpStatus, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { loginDto } from './dto';
import { customResponse } from 'src/utils/response.util';
import { Prisma, User } from '@prisma/client';
import * as argon from 'argon2';
import { JwtGuard } from './guard';

@Controller('api')
export class AuthController {
  constructor(private readonly authService: AuthService) { }
  
  @Post('login')
  async login(@Body() loginAuthDto: loginDto, @Res() response) {
    try {
      const data = await this.authService.login(loginAuthDto);
      if (data === null) {
        customResponse(response, `Email/password is wrong`, HttpStatus.BAD_REQUEST);
      }

      const registerToken = await this.authService.registerToken(data);

      customResponse(response, `Login successfully`, HttpStatus.OK, data, registerToken);
    } catch (error) {
      customResponse(response, `Login failed : ${error}`, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Post('register')
  async register(@Body() userRegisterDto: Prisma.UserCreateInput, @Res() response) {
    try {

      const hashPassword = await argon.hash(userRegisterDto.password);
      userRegisterDto.password = hashPassword;
      const data = await this.authService.register(userRegisterDto);
      const registerToken = await this.authService.registerToken(data);

      customResponse(response, `Register successfully`, HttpStatus.OK, data, registerToken);
    } catch (error) {
      customResponse(response, `Register Failed : ${error}`, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
