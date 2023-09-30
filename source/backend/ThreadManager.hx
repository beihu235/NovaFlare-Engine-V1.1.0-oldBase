package backend;

import hx.concurrent.thread.*;

class ThreadManager {
    public var pool:ThreadPool;

    public function startThread() {
        pool = new ThreadPool(1);
        
    }

    public function stopThread() {
        if (pool.isRunning()) {
            pool.cancelPendingTasks();
            pool.stop();
        }
    }

    public function runThread() {
     pool.submit(function(ctx:ThreadContext) {
         // do some work here
        });
    }
}

