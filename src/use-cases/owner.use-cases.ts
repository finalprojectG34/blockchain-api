import OwnerEntity from "../entities/owner.entity";
import OwnerRepositoryInterface from "./owner.repository.interface";

export default class OwnerUseCases {
  constructor(private ownerRepository: OwnerRepositoryInterface) {}

  getOwnerByAddress(address: string): Promise<OwnerEntity | undefined> {
    return this.ownerRepository.getOwnerByAddress(address);
  }

  async createOwner(data: OwnerEntity): Promise<OwnerEntity> {
    return await this.ownerRepository.createOwner(data);
  }
}
