export interface CategoryScore {
  score: number;  // 0-1 score
  weight: number; // Category weight
}

export interface QuestionnaireCompatibility {
  coreValues: CategoryScore;
  relationshipApproach: CategoryScore;
  communicationConflict: CategoryScore;
  emotionalSocial: CategoryScore;
  personalCharacteristics: CategoryScore;
  total: number; // Out of 50
}

// Scoring constants
export const MATCH_SCORES = {
  EXACT: 1.0,      // 100% - Perfect match
  COMPLEMENTARY: 0.7, // 70% - Compatible but different
  NEUTRAL: 0.3,    // 30% - Not conflicting but not aligned
  OPPOSING: 0.0    // 0% - Directly conflicting
} as const;

// Category weights (total: 50%)
export const CATEGORY_WEIGHTS = {
  CORE_VALUES: 0.15,
  RELATIONSHIP_APPROACH: 0.10,
  COMMUNICATION_CONFLICT: 0.10,
  EMOTIONAL_SOCIAL: 0.08,
  PERSONAL_CHARACTERISTICS: 0.07
} as const;

// Rating categories mapping
export const RATING_CATEGORIES = {
  coreValues: {
    values: ['humor', 'spirituality', 'family'],
    lifestyle: ['nature_vs_city', 'academic_success', 'workout', 'social_life'],
    personality: ['growth_mindset', 'ambition']
  },
  relationshipApproach: {
    values: ['commitment', 'relationship_roles', 'boundaries'],
    personality: ['decisiveness', 'independence']
  },
  communicationConflict: {
    personality: ['communication_style', 'conflict_resolution', 'emotional_intelligence'],
    values: ['honesty', 'respect']
  },
  emotionalSocial: {
    personality: ['empathy', 'social_awareness', 'emotional_stability'],
    values: ['trust', 'loyalty']
  },
  personalCharacteristics: {
    personality: ['creativity', 'organization', 'adaptability', 'stress_management'],
    lifestyle: ['routine', 'spontaneity']
  }
} as const;
