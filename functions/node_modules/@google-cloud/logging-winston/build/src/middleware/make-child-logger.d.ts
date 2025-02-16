import * as winston from 'winston';
export declare function makeChildLogger(logger: winston.Logger, trace: string, span?: string, sampled?: boolean): winston.Logger;
