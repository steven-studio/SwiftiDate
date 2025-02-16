import { Detector, DetectorSync, Resource } from '@opentelemetry/resources';
declare function detect(): Promise<Resource>;
/**
 * Async Google Cloud resource detector which populates attributes based the on environment
 * this process is running in. If not on GCP, returns an empty resource.
 *
 * @deprecated Async resource detectors are deprecated. Please use {@link GcpDetectorSync} instead.
 */
export declare class GcpDetector implements Detector {
    detect: typeof detect;
}
/**
 * Google Cloud resource detector which populates attributes based on the environment this
 * process is running in. If not on GCP, returns an empty resource.
 */
export declare class GcpDetectorSync implements DetectorSync {
    private _asyncAttributes;
    detect(): Resource;
}
export {};
