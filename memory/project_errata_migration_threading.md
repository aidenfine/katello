---
name: errata-migration-threading
description: populate_errata_applications.rake was converted from sequential to multi-threaded batch processing (4 threads, shared Queue, Mutex for counters)
metadata:
  type: project
---

The upgrade task `katello:upgrades:4.21:populate_errata_applications` was refactored to process batches in parallel using 4 threads with a shared `Queue` and `Mutex` for thread-safe counter updates.

**Why:** Performance improvement for the historical errata application migration, which can involve large numbers of RunHostJob tasks.

**How to apply:** Future changes to this rake task should preserve the thread-safe design (mutex-guarded counters, queue-based batch distribution, nil sentinels for shutdown). `bulk_record_from_tasks` must be safe to call concurrently from multiple threads.
