import OwnerEntity from "../../entities/owner.entity";

export default interface OwnerRepositoryInterface {
    getOwnerByAddress(id: string): Promise<OwnerEntity | undefined>;

    createOwner(data: OwnerEntity): Promise<OwnerEntity>;
}