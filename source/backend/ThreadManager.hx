package backend;

import hx.concurrent.thread.*;

class ThreadManager {
    public var thread:Thread;

    public function startThread() {
        thread = new Thread(runThread);
        thread.start();
    }

    public function stopThread() {
        if (thread.isRunning()) {
            thread.stop();
        }
    }

    public function runThread() {
     
    }
}