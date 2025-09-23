import * as cron from 'node-cron';
import { bankingService } from '../services/bankingService';

export class InterestJob {
  private static instance: InterestJob;
  private task: cron.ScheduledTask | null = null;

  private constructor() {}

  public static getInstance(): InterestJob {
    if (!InterestJob.instance) {
      InterestJob.instance = new InterestJob();
    }
    return InterestJob.instance;
  }

  public start(): void {
    // Run at 00:00 UTC daily
    this.task = cron.schedule('0 0 * * *', async () => {
      console.log('Starting daily interest offers job...');
      try {
        await bankingService.createDailyInterestOffers();
        console.log('Daily interest offers job completed successfully');
      } catch (error) {
        console.error('Daily interest offers job failed:', error);
      }
    }, {
      scheduled: true,
      timezone: 'UTC'
    });

    console.log('Daily interest offers job scheduled for 00:00 UTC');
  }

  public stop(): void {
    if (this.task) {
      this.task.stop();
      this.task = null;
      console.log('Daily interest offers job stopped');
    }
  }

  // Manual trigger for testing
  public async runNow(): Promise<void> {
    console.log('Manually triggering daily interest offers job...');
    try {
      await bankingService.createDailyInterestOffers();
      console.log('Manual interest offers job completed successfully');
    } catch (error) {
      console.error('Manual interest offers job failed:', error);
      throw error;
    }
  }
}

export const interestJob = InterestJob.getInstance();
