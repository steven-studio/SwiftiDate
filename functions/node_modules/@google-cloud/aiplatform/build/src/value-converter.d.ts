export interface ValueType {
    [index: string]: null | boolean | string | number | ValueType | Array<string | number | ValueType>;
}
export declare function googleProtobufValueFromObject(object: ValueType, create: (result: object) => object): object | null | ValueType | protobuf.common.IValue;
export declare function googleProtobufValueToObject(message: protobuf.common.IValue): object | null | undefined | boolean | number | string;
