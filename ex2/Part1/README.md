# Mutex and Channel basics

### What is an atomic operation?
> An atomic operation is an operation that completes entirely without any chance of being interrupted. Thus the data an atomic operation uses for calculations cannot be left half-completed.

### What is a semaphore?
> A semaphore is a synchronization primitive that can be used to control access to shared resources. It has a minimum value of 0 and often a user specifiable maximum value. Two (atomic) operations are typically performed on semaphores: Waiting, which tries to decrement the semaphore value but blocks the calling process if the value is less than 1, and signalling, which signals to the semaphore to increment its value and signal to other processes that the semaphore is free.

### What is a mutex?
> A mutex is a special kind of binary semaphore that only has two possible values. It is locked when its value is 0 and unlocked when the value is 1. The value is controlled similarly to a regular semaphore, but a mutex differs from a regular binary semaphore that only the locking process can unlock it.

### What is the difference between a mutex and a binary semaphore?
> See above.

### What is a critical section?
> A critical section is a part of the code that accesses and/or modifies some shared data.

### What is the difference between race conditions and data races?
> A race condition is when the result of some operations depend on the (unspecified) order of the said operations. A data race is when multiple processes access shared data concurrently.

### List some advantages of using message passing over lock-based synchronization primitives.
> Message passing is relatively simple to implement and use, while lock-based synchronization often require special memory protection and more care from the programmer. The queues message-passing offers are very convenient for high latency communication.

### List some advantages of using lock-based synchronization primitives over message passing.
> Lock-based synchronization allow much more data to be shared between processes. While message passing is convenient for small transmission sizes it requires much more frequent context switches, imposing more overhead. Locks are often faster than message-passing channels to setup as well.
