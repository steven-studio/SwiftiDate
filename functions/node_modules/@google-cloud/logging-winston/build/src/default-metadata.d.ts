/**
 * Returns an object that can be passed to Winston.createLogger as defaultMeta
 * to allow log-trace correlation with Winston 3. Log-trace correlation with
 * Winston 3 is broken because the trace ID to be correlated with a log isn't
 * evaluated when the log function is called, but rather when the log is
 * written, which happens at some future point where the trace ID may no longer
 * be accurate. To circumvent this, we take advantage of the fact that
 * defaultMeta is copied when a log function is called, and use a dynamic
 * property getter to evaluate the trace ID upon that copy.
 *
 * We apply the same principle for timestamps, which is not strictly necessary
 * for tracing but allows for more accurate timestamps in general.
 *
 * If there are other default metadata fields with which the return value of
 * this function must be merged, this object MUST be the base object. In other
 * words, do not use the return value of this function as the non-first argument
 * to Object.assign, or it will not work.
 *
 * See https://github.com/googleapis/nodejs-logging-winston/issues/287 for
 * more information.
 */
export declare function getDefaultMetadataForTracing(): {};
