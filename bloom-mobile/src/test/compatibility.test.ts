import { calculateCompatibility } from '../services/compatibility';
import { BirthData, ZodiacSign } from '../types/compatibility';

// Helper function to create test birth data for a specific date
function createTestBirthData(year: number, month: number, day: number): BirthData {
  return {
    date: new Date(year, month - 1, day), // month is 0-based
    time: "12:00",
    latitude: 40.7128, // New York City coordinates
    longitude: -74.0060,
    timezone: "America/New_York"
  };
}

// Test birth data for each zodiac sign
const testBirthData = {
  Aries: createTestBirthData(1990, 3, 25),      // March 25
  Taurus: createTestBirthData(1990, 4, 25),     // April 25
  Gemini: createTestBirthData(1990, 5, 25),     // May 25
  Cancer: createTestBirthData(1990, 6, 25),     // June 25
  Leo: createTestBirthData(1990, 7, 25),        // July 25
  Virgo: createTestBirthData(1990, 8, 25),      // August 25
  Libra: createTestBirthData(1990, 9, 25),      // September 25
  Scorpio: createTestBirthData(1990, 10, 25),   // October 25
  Sagittarius: createTestBirthData(1990, 11, 25),// November 25
  Capricorn: createTestBirthData(1990, 12, 25), // December 25
  Aquarius: createTestBirthData(1990, 1, 25),   // January 25
  Pisces: createTestBirthData(1990, 2, 25)      // February 25
};

describe('Compatibility Calculations', () => {
  describe('calculateCompatibility', () => {
    it('should calculate total compatibility with questionnaire score', () => {
      const result = calculateCompatibility(testBirthData.Aries, testBirthData.Leo, 80);
      expect(result.score.total).toBeDefined();
      expect(result.score.questionnaire).toBe(80);
      expect(result.score.astrological.total).toBeDefined();
    });

    it('should default to middle questionnaire score if not provided', () => {
      const result = calculateCompatibility(testBirthData.Aries, testBirthData.Leo);
      expect(result.score.questionnaire).toBe(50);
    });

    it('should calculate high compatibility for matching elements', () => {
      const result = calculateCompatibility(testBirthData.Aries, testBirthData.Leo);
      expect(result.score.astrological.element.elementScore).toBeGreaterThan(80);
      expect(result.astrologicalDetails).toContain('naturally harmonious match');
    });

    it('should calculate lower compatibility for challenging elements', () => {
      const result = calculateCompatibility(testBirthData.Aries, testBirthData.Cancer);
      expect(result.score.astrological.element.elementScore).toBeLessThan(60);
      expect(result.astrologicalDetails).toContain('natural challenges');
    });

    it('should provide detailed compatibility explanations', () => {
      const result = calculateCompatibility(testBirthData.Taurus, testBirthData.Cancer);
      expect(result.astrologicalDetails).toBeTruthy();
      expect(result.astrologicalDetails).toContain('Earth and Water');
      expect(result.aspectDetails).toBeTruthy();
      expect(result.elementDetails).toBeTruthy();
    });

    it('should handle same sign compatibility', () => {
      const signs = Object.keys(testBirthData) as ZodiacSign[];

      signs.forEach(sign => {
        const result = calculateCompatibility(testBirthData[sign], testBirthData[sign]);
        expect(result.score.total).toBeGreaterThanOrEqual(0);
        expect(result.score.total).toBeLessThanOrEqual(100);
        expect(result.astrologicalDetails).toContain(sign);
      });
    });

    it('should calculate symmetric compatibility scores', () => {
      const result1 = calculateCompatibility(testBirthData.Libra, testBirthData.Aquarius);
      const result2 = calculateCompatibility(testBirthData.Aquarius, testBirthData.Libra);
      expect(result1.score.total).toBe(result2.score.total);
      expect(result1.score.astrological.total).toBe(result2.score.astrological.total);
      expect(result1.score.astrological.aspect.total).toBe(result2.score.astrological.aspect.total);
      expect(result1.score.astrological.element.elementScore).toBe(result2.score.astrological.element.elementScore);
    });

    describe('Birth Time and Location Effects', () => {
      it('should handle different birth times', () => {
        const morningBirth: BirthData = {
          ...testBirthData.Leo,
          time: "06:00"
        };
        const eveningBirth: BirthData = {
          ...testBirthData.Leo,
          time: "18:00"
        };
        
        const result = calculateCompatibility(morningBirth, eveningBirth);
        expect(result.score.total).toBeDefined();
        expect(result.score.astrological.aspect.aspectDetails).toBeDefined();
      });

      it('should handle different locations', () => {
        const newYorkBirth: BirthData = testBirthData.Leo;
        const tokyoBirth: BirthData = {
          ...testBirthData.Leo,
          latitude: 35.6762,
          longitude: 139.6503,
          timezone: "Asia/Tokyo"
        };
        
        const result = calculateCompatibility(newYorkBirth, tokyoBirth);
        expect(result.score.total).toBeDefined();
        expect(result.score.astrological.aspect.aspectDetails).toBeDefined();
      });
    });

    describe('Aspect Compatibility', () => {
      it('should calculate aspect compatibility with birth data', () => {
        const result = calculateCompatibility(testBirthData.Leo, testBirthData.Libra);
        expect(result.score.astrological.aspect.total).toBeDefined();
        expect(result.score.astrological.aspect.aspectScore).toBeDefined();
        expect(result.score.astrological.aspect.elementScore).toBeDefined();
        expect(result.score.astrological.aspect.aspectDetails.length).toBeGreaterThan(0);
      });

      it('should provide aspect details', () => {
        const result = calculateCompatibility(testBirthData.Leo, testBirthData.Libra);
        expect(result.aspectDetails).toContain('Planetary Aspects');
        expect(result.aspectDetails).toMatch(/\d+% strength/);
      });
    });
  });
});
