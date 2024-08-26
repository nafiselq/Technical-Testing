import { loginDto } from './dto/auth.dto';
import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { DatabaseService } from 'src/database/database.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as argon from 'argon2';

@Injectable()
export class AuthService {
  constructor(
    private readonly databaseService: DatabaseService,
    private jwt: JwtService,
    private config: ConfigService
  ) { }
  async register(createAuthDto: Prisma.UserCreateInput) {
    return this.databaseService.user.create({ data: createAuthDto });
  }

  async login(loginAuthDto: loginDto) {
    const checkExistEmailUser = await this.databaseService.user.findUnique({ where: { email: loginAuthDto.email } });

    if (!checkExistEmailUser) {
      return null;
    }

    const pwMatches = await argon.verify(
      checkExistEmailUser.password,
      loginAuthDto.password
    );

    if (!pwMatches) {
      return null;
    }


    delete checkExistEmailUser.password
    return checkExistEmailUser;
  }


  async registerToken(user: any): Promise<string> {
    const secret = this.config.get('JWT_SECRET')
    return this.jwt.signAsync(user, {
      expiresIn: '365d',
      secret
    })
  }

  async getMe(id: number) {
    const user = await this.databaseService.user.findUnique({
      where: { id }
    })

    return user;
  }
}
