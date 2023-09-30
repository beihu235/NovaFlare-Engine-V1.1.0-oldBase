package backend;

import hx.concurrent.executor.Schedule;
import hx.concurrent.executor.Executor;

class ThreadManager_new {
    public function startThread() {
      var executor = Executor.create(3);  // <- 3 means to use a thread pool of 3 threads on platforms that support threads
      // depending on the platform either a thread-based or timer-based implementation is returned

      // define a function to be executed concurrently/async/scheduled (return type can also be Void)
      var myTask = function():Date {
         trace("Executing...");
         return Date.now();
      }

      // submit 10 tasks each to be executed once asynchronously/concurrently as soon as possible
      for (i in 0...10) {
         executor.submit(myTask);
      }

      executor.submit(myTask, ONCE(2000));            // async one-time execution with a delay of 2 seconds
      executor.submit(myTask, FIXED_RATE(200));       // repeated async execution every 200ms
      executor.submit(myTask, FIXED_DELAY(200));      // repeated async execution 200ms after the last execution
      executor.submit(myTask, HOURLY(30));            // async execution 30min after each full hour
      executor.submit(myTask, DAILY(3, 30));          // async execution daily at 3:30
      executor.submit(myTask, WEEKLY(SUNDAY, 3, 30)); // async execution Sundays at 3:30

      // submit a task and keep a reference to it
      var future = executor.submit(myTask, FIXED_RATE(200));

      // check if a result is already available
      switch (future.result) {
         case VALUE(value, time, _): trace('Successfully execution at ${Date.fromTime(time)} with result: $value');
         case FAILURE(ex, time, _):  trace('Execution failed at ${Date.fromTime(time)} with exception: $ex');
         case PENDING(_):            trace("No result yet...");
      }

      // check if the task is scheduled to be executed (again) in the future
      if (!future.isStopped) {
         trace('The task is scheduled for further executions with schedule: ${future.schedule}');
      }

      // cancel any future execution of the task
      future.cancel();
   }
}


