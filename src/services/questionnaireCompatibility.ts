import { Profile } from '../types/database';

/**
 * Extended profile type that includes questionnaire answers
 */
export interface ExtendedProfile extends Profile {
  // Multiple choice questionnaire answers
  decision_making?: string;
  social_behavior?: string;
  conflict_handling?: string;
  life_goals?: string;
  relationship_role?: string;
  free_time?: string;
  self_investment?: string;
  commitment_approach?: string;
  relationship_value?: string;
  care_expression?: string;
  ideal_lifestyle?: string;
  difficult_situations?: string;
  personal_growth?: string;
  dating_approach?: string;
  commitment_preference?: string;
  communication_style?: string;
  relationship_values?: string;
  relationship_roles?: string;
  relationship_offering?: string;
  partner_expectations?: string;
  partner_evaluation?: string;
  problem_solving?: string;
  future_planning?: string;
  boundary_approach?: string;
  relationship_success?: string;
}

/**
 * Calculate compatibility between two users' personality ratings
 * @param ratings1 First user's personality ratings
 * @param ratings2 Second user's personality ratings
 * @returns Compatibility score (0-100)
 */
export function calculatePersonalityCompatibility(
  ratings1: Record<string, number>,
  ratings2: Record<string, number>
): number {
  // Calculate similarity between ratings
  let totalDifference = 0;
  let totalPossibleDifference = 0;
  let comparedItems = 0;
  
  for (const [key, value1] of Object.entries(ratings1)) {
    if (key in ratings2) {
      const value2 = ratings2[key];
      totalDifference += Math.abs(value1 - value2);
      totalPossibleDifference += 9; // Max difference on 1-10 scale
      comparedItems++;
    }
  }
  
  // Convert to similarity percentage (0-100)
  return comparedItems > 0
    ? 100 - (totalDifference / totalPossibleDifference) * 100
    : 50; // Default to middle value if no comparison possible
}

/**
 * Calculate compatibility between two users' lifestyle ratings
 * @param ratings1 First user's lifestyle ratings
 * @param ratings2 Second user's lifestyle ratings
 * @returns Compatibility score (0-100)
 */
export function calculateLifestyleCompatibility(
  ratings1: Record<string, number>,
  ratings2: Record<string, number>
): number {
  // Calculate similarity between ratings
  let totalDifference = 0;
  let totalPossibleDifference = 0;
  let comparedItems = 0;
  
  for (const [key, value1] of Object.entries(ratings1)) {
    if (key in ratings2) {
      const value2 = ratings2[key];
      totalDifference += Math.abs(value1 - value2);
      totalPossibleDifference += 9; // Max difference on 1-10 scale
      comparedItems++;
    }
  }
  
  // Convert to similarity percentage (0-100)
  return comparedItems > 0
    ? 100 - (totalDifference / totalPossibleDifference) * 100
    : 50; // Default to middle value if no comparison possible
}

/**
 * Calculate compatibility between two users' values ratings
 * @param ratings1 First user's values ratings
 * @param ratings2 Second user's values ratings
 * @returns Compatibility score (0-100)
 */
export function calculateValuesCompatibility(
  ratings1: Record<string, number>,
  ratings2: Record<string, number>
): number {
  // Calculate similarity between ratings
  let totalDifference = 0;
  let totalPossibleDifference = 0;
  let comparedItems = 0;
  
  for (const [key, value1] of Object.entries(ratings1)) {
    if (key in ratings2) {
      const value2 = ratings2[key];
      totalDifference += Math.abs(value1 - value2);
      totalPossibleDifference += 9; // Max difference on 1-10 scale
      comparedItems++;
    }
  }
  
  // Convert to similarity percentage (0-100)
  return comparedItems > 0
    ? 100 - (totalDifference / totalPossibleDifference) * 100
    : 50; // Default to middle value if no comparison possible
}

/**
 * Calculate compatibility between two users' multiple choice question answers
 * @param answers1 First user's answers
 * @param answers2 Second user's answers
 * @returns Compatibility score (0-100)
 */
export function calculateMultipleChoiceCompatibility(
  answers1: Record<string, string>,
  answers2: Record<string, string>
): number {
  let matches = 0;
  let total = 0;
  
  for (const [key, value1] of Object.entries(answers1)) {
    if (key in answers2) {
      const value2 = answers2[key];
      if (value1 === value2) {
        matches++;
      }
      total++;
    }
  }
  
  // Convert to percentage (0-100)
  return total > 0
    ? (matches / total) * 100
    : 50; // Default to middle value if no comparison possible
}

/**
 * Calculate overall questionnaire compatibility between two profiles
 * @param profile1 First user's profile
 * @param profile2 Second user's profile
 * @returns Compatibility details with scores for different categories
 */
export function calculateQuestionnaireCompatibility(
  profile1: ExtendedProfile,
  profile2: ExtendedProfile
): {
  total: number;
  personality: number;
  lifestyle: number;
  values: number;
  multipleChoice: number;
} {
  // Calculate personality compatibility
  const personalityScore = calculatePersonalityCompatibility(
    profile1.personality_ratings || {},
    profile2.personality_ratings || {}
  );
  
  // Calculate lifestyle compatibility
  const lifestyleScore = calculateLifestyleCompatibility(
    profile1.lifestyle_ratings || {},
    profile2.lifestyle_ratings || {}
  );
  
  // Calculate values compatibility
  const valuesScore = calculateValuesCompatibility(
    profile1.values_ratings || {},
    profile2.values_ratings || {}
  );
  
  // Extract multiple choice answers
  const profile1Answers: Record<string, string> = {
    decision_making: profile1.decision_making || '',
    social_behavior: profile1.social_behavior || '',
    conflict_handling: profile1.conflict_handling || '',
    life_goals: profile1.life_goals || '',
    relationship_role: profile1.relationship_role || '',
    free_time: profile1.free_time || '',
    self_investment: profile1.self_investment || '',
    commitment_approach: profile1.commitment_approach || '',
    relationship_value: profile1.relationship_value || '',
    care_expression: profile1.care_expression || '',
    ideal_lifestyle: profile1.ideal_lifestyle || '',
    difficult_situations: profile1.difficult_situations || '',
    personal_growth: profile1.personal_growth || '',
    dating_approach: profile1.dating_approach || '',
    commitment_preference: profile1.commitment_preference || '',
    communication_style: profile1.communication_style || '',
    relationship_values: profile1.relationship_values || '',
    relationship_roles: profile1.relationship_roles || '',
    relationship_offering: profile1.relationship_offering || '',
    partner_expectations: profile1.partner_expectations || '',
    partner_evaluation: profile1.partner_evaluation || '',
    problem_solving: profile1.problem_solving || '',
    future_planning: profile1.future_planning || '',
    boundary_approach: profile1.boundary_approach || '',
    relationship_success: profile1.relationship_success || '',
  };
  
  const profile2Answers: Record<string, string> = {
    decision_making: profile2.decision_making || '',
    social_behavior: profile2.social_behavior || '',
    conflict_handling: profile2.conflict_handling || '',
    life_goals: profile2.life_goals || '',
    relationship_role: profile2.relationship_role || '',
    free_time: profile2.free_time || '',
    self_investment: profile2.self_investment || '',
    commitment_approach: profile2.commitment_approach || '',
    relationship_value: profile2.relationship_value || '',
    care_expression: profile2.care_expression || '',
    ideal_lifestyle: profile2.ideal_lifestyle || '',
    difficult_situations: profile2.difficult_situations || '',
    personal_growth: profile2.personal_growth || '',
    dating_approach: profile2.dating_approach || '',
    commitment_preference: profile2.commitment_preference || '',
    communication_style: profile2.communication_style || '',
    relationship_values: profile2.relationship_values || '',
    relationship_roles: profile2.relationship_roles || '',
    relationship_offering: profile2.relationship_offering || '',
    partner_expectations: profile2.partner_expectations || '',
    partner_evaluation: profile2.partner_evaluation || '',
    problem_solving: profile2.problem_solving || '',
    future_planning: profile2.future_planning || '',
    boundary_approach: profile2.boundary_approach || '',
    relationship_success: profile2.relationship_success || '',
  };
  
  // Calculate multiple choice compatibility
  const multipleChoiceScore = calculateMultipleChoiceCompatibility(
    profile1Answers,
    profile2Answers
  );
  
  // Calculate total score with weighted components
  // Personality: 30%, Lifestyle: 25%, Values: 25%, Multiple Choice: 20%
  const totalScore = (
    personalityScore * 0.3 +
    lifestyleScore * 0.25 +
    valuesScore * 0.25 +
    multipleChoiceScore * 0.2
  );
  
  return {
    total: Math.round(totalScore),
    personality: Math.round(personalityScore),
    lifestyle: Math.round(lifestyleScore),
    values: Math.round(valuesScore),
    multipleChoice: Math.round(multipleChoiceScore)
  };
}
