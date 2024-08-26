import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { DatabaseService } from 'src/database/database.service';

@Injectable()
export class ProductsService {
  constructor(private readonly databaseService: DatabaseService) { }
  create(createProductDto: Prisma.ProductCreateInput) {
    return this.databaseService.product.create({ data: createProductDto })
  }

  getDatatables(limit: number, page: number, search: string) {
    const take = typeof limit === 'string' ? parseInt(limit, 10) : limit;
    const skip = (page - 1) * limit
    return this.databaseService.product.findMany({
      where: {
        OR: [
          {
            name: {
              contains: search,
            },
          },
        ],
      },
      take,
      skip,
    });
  }

  totalRow(search: string) {
    return this.databaseService.product.count({
      where: {
        OR: [
          {
            name: {
              contains: search,
            },
          },
          // Tambahkan kondisi pencarian lain di sini jika diperlukan
        ],
      }
    })
  }

  findOne(id: number) {
    return this.databaseService.product.findUnique({ where: { id: id } })
  }

  update(id: number, updateProductDto: Prisma.ProductUpdateInput) {
    return this.databaseService.product.update({ where: { id }, data: updateProductDto })
  }

  remove(id: number) {
    return this.databaseService.product.delete({ where: { id } })
  }
}
