import { Controller, Get, Post, Body, Param, Delete, Res, HttpStatus, UseGuards, Query, Req, UseInterceptors, UploadedFile, Put } from '@nestjs/common';
import { ProductsService } from './products.service';
import { Prisma } from '@prisma/client';
import { customResponse } from 'src/utils/response.util';
import { JwtGuard } from 'src/auth/guard';
import { Request, Response } from 'express';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import * as path from 'path';
import { v4 as uuidv4 } from 'uuid';
import * as fs from 'fs/promises';

@Controller('api/products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) { }

  @Post()
  @UseInterceptors(FileInterceptor('image', {
    storage: diskStorage({
      destination: './uploads/products',
      filename: (req, file, cb) => {
        const filename: string = path.parse(file.originalname).name.replace(/\s/g, '') + uuidv4();
        const extension: string = path.parse(file.originalname).ext;

        cb(null, `${filename}${extension}`)
      }
    })
  }))
  async create(@Body() createProductDto: any, @Res() response: Response, @UploadedFile() file) {
    try {

      if (file?.path === undefined) {
        customResponse(response, `Image can not be empty`, HttpStatus.FORBIDDEN);
      }

      createProductDto.image = file.path;
      const productData: Prisma.ProductCreateInput = {
        name: createProductDto.name,
        desc: createProductDto.desc,
        price: typeof createProductDto.price === 'string' ? parseInt(createProductDto.price, 10) : 0,
        image: createProductDto.image,
        lat: createProductDto.lat,
        long: createProductDto.long
      }

      const data = await this.productsService.create(productData);

      customResponse(response, `Success Create Product`, HttpStatus.CREATED, data);
    } catch (error) {
      console.log("ini error : ", error);
      customResponse(response, error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @UseGuards(JwtGuard)
  @Get()
  async findDataTable(@Res() response: Response, @Query('search') search: string, @Query('page') page: number, @Req() request: Request) {
    try {
      const protocol = request.protocol;
      const host = request.get('host');
      const baseUrl = `${protocol}://${host}`;

      const data = await this.productsService.getDatatables(10, page ?? 1, search);
      data.map((element) => {
        element.image = `${baseUrl}/${element.image}`
      })
      customResponse(response, `Get Products Successfully`, HttpStatus.OK, data);
    } catch (error) {
      customResponse(response, `Find Datatable Failed : ${error}`, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @Res() response: Response) {
    try {
      const data = await this.productsService.findOne(parseInt(id))

      if (!data) customResponse(response, `Product not found`, HttpStatus.NOT_FOUND);
      customResponse(response, `Success Get Detail Product`, HttpStatus.OK, data);
    } catch (error) {
      customResponse(response, error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Put(':id')
  @UseInterceptors(FileInterceptor('image', {
    storage: diskStorage({
      destination: './uploads/products',
      filename: (req, file, cb) => {
        const filename: string = path.parse(file.originalname).name.replace(/\s/g, '') + uuidv4();
        const extension: string = path.parse(file.originalname).ext;

        cb(null, `${filename}${extension}`)
      }
    })
  }))
  async update(@Param('id') id: string, @Body() updateProductDto: any, @Res() response: Response, @UploadedFile() file) {
    try {
      const existingProduct = await this.productsService.findOne(+id);
      if (file?.path !== undefined) {
        if (existingProduct?.image) {
          await fs.unlink(existingProduct.image);
        }
        updateProductDto.image = file.path;
      }

      

      const productData: Prisma.ProductUpdateInput = {
        desc: updateProductDto.desc,
        name: updateProductDto.name,
        price: typeof updateProductDto.price === 'string' && parseInt(updateProductDto.price, 10),
        image: updateProductDto.image,
        lat: updateProductDto.lat,
        long: updateProductDto.long
      }
      const data = await this.productsService.update(+id, productData);
      customResponse(response, `Success Update Products`, HttpStatus.CREATED, data);
    } catch (error) {
      console.log("ini error : ", error);
      customResponse(response, error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Delete(':id')
  async remove(@Param('id') id: string, @Res() response: Response) {
    try {
      await this.productsService.remove(+id);
      customResponse(response, `Success Delete Products`, HttpStatus.OK);
    } catch (error) {
      customResponse(response, error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
