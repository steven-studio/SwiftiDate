/**
 * Log function to use for debug output. By default, we don't perform any
 * logging.
 *
 * @private
 * @internal
 */
export declare function logger(source: string, msg: string, ...otherArgs: any[]): void;
/**
 * Sets or disables the log function for all active BigQuery instances.
 *
 * @param logger A log function that takes a message (such as `console.log`) or
 * `null` to turn off logging.
 */
export declare function setLogFunction(logger: ((msg: string) => void) | null): void;
