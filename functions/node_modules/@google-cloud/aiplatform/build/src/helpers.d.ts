import { ValueType } from './value-converter';
interface ToValueFunction {
    toValue(): null | object | undefined;
    $type: unknown;
    toJson(): string;
}
export declare function addToValue(): ToValueFunction;
/**
 * Converts an object or protobuf.Message to a protobuf.Value object.
 * @param message Object or protobuf.Message to convert
 * @returns a Value-formatted object
 */
export declare function toValue(message: protobuf.Message | object): null | object | undefined | protobuf.common.IValue;
/**
 * Creates instance of class from a protobuf.Value object.
 * @param value Value to convert
 * @returns a Message
 */
export declare function fromValue(value: protobuf.common.IValue): object | null | undefined | string | number | ValueType | boolean;
export {};
