import { Profile } from '../types/database';
import { calculateQuestionnaireCompatibility, updateMatchScores } from '../services/compatibility';

describe('Compatibility Calculation', () => {
  const mockProfile1: Profile = {
    id: '1',
    email: 'test1@example.com',
    birth_date: null,
    location_city: null,
    personality_ratings: {
      communication_style: 4,
      emotional_intelligence: 5,
      creativity: 3,
      organization: 4,
      adaptability: 5,
      stress_management: 4,
      growth_mindset: 5,
      ambition: 4,
      decisiveness: 3,
      independence: 4,
      empathy: 5,
      social_awareness: 4,
      emotional_stability: 4
    },
    lifestyle_ratings: {
      nature_vs_city: 4,
      academic_success: 5,
      workout: 4,
      social_life: 3,
      routine: 4,
      spontaneity: 3
    },
    values_ratings: {
      humor: 5,
      spirituality: 3,
      family: 4,
      commitment: 5,
      relationship_roles: 4,
      boundaries: 5,
      honesty: 5,
      respect: 5,
      trust: 5,
      loyalty: 5
    },
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };

  const mockProfile2: Profile = {
    id: '2',
    email: 'test2@example.com',
    birth_date: null,
    location_city: null,
    personality_ratings: {
      communication_style: 5,
      emotional_intelligence: 4,
      creativity: 4,
      organization: 3,
      adaptability: 5,
      stress_management: 4,
      growth_mindset: 5,
      ambition: 5,
      decisiveness: 4,
      independence: 3,
      empathy: 5,
      social_awareness: 5,
      emotional_stability: 4
    },
    lifestyle_ratings: {
      nature_vs_city: 3,
      academic_success: 5,
      workout: 5,
      social_life: 4,
      routine: 3,
      spontaneity: 4
    },
    values_ratings: {
      humor: 4,
      spirituality: 4,
      family: 5,
      commitment: 5,
      relationship_roles: 4,
      boundaries: 4,
      honesty: 5,
      respect: 5,
      trust: 5,
      loyalty: 5
    },
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };

  describe('calculateQuestionnaireCompatibility', () => {
    it('calculates category scores correctly', () => {
      const result = calculateQuestionnaireCompatibility(mockProfile1, mockProfile2);

      // All scores should be between 0 and 1
      expect(result.coreValues.score).toBeGreaterThanOrEqual(0);
      expect(result.coreValues.score).toBeLessThanOrEqual(1);
      expect(result.relationshipApproach.score).toBeGreaterThanOrEqual(0);
      expect(result.relationshipApproach.score).toBeLessThanOrEqual(1);
      expect(result.communicationConflict.score).toBeGreaterThanOrEqual(0);
      expect(result.communicationConflict.score).toBeLessThanOrEqual(1);
      expect(result.emotionalSocial.score).toBeGreaterThanOrEqual(0);
      expect(result.emotionalSocial.score).toBeLessThanOrEqual(1);
      expect(result.personalCharacteristics.score).toBeGreaterThanOrEqual(0);
      expect(result.personalCharacteristics.score).toBeLessThanOrEqual(1);

      // Total should be between 0 and 50
      expect(result.total).toBeGreaterThanOrEqual(0);
      expect(result.total).toBeLessThanOrEqual(50);
    });

    it('handles similar profiles with high compatibility', () => {
      const result = calculateQuestionnaireCompatibility(mockProfile1, mockProfile1);
      expect(result.total).toBeGreaterThanOrEqual(45); // Should be very high for identical profiles
    });

    it('handles missing ratings gracefully', () => {
      const incompleteProfile: Profile = {
        ...mockProfile1,
        personality_ratings: {},
        lifestyle_ratings: {},
        values_ratings: {}
      };

      const result = calculateQuestionnaireCompatibility(incompleteProfile, mockProfile2);
      expect(result.total).toBe(0); // Should handle missing data without errors
    });
  });

  describe('updateMatchScores', () => {
    it('calculates all scores correctly', async () => {
      const mockMatch = {
        id: '1',
        user1_id: '1',
        user2_id: '2'
      };

      const result = await updateMatchScores(mockMatch, mockProfile1, mockProfile2);

      // All scores should be between 0 and 1
      expect(result.compatibility_score).toBeGreaterThanOrEqual(0);
      expect(result.compatibility_score).toBeLessThanOrEqual(1);
      expect(result.questionnaire_score).toBeGreaterThanOrEqual(0);
      expect(result.questionnaire_score).toBeLessThanOrEqual(1);
      expect(result.astrological_score).toBeGreaterThanOrEqual(0);
      expect(result.astrological_score).toBeLessThanOrEqual(1);

      // Verify questionnaire score is 50% of total
      const expectedQuestionnaireContribution = result.questionnaire_score * 0.5;
      const expectedAstrologicalContribution = result.astrological_score * 0.5;
      expect(result.compatibility_score).toBeCloseTo(
        expectedQuestionnaireContribution + expectedAstrologicalContribution
      );
    });
  });
});
