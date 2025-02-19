import { ZodiacSign, PlanetaryBody, Element, BaseCompatibilityScore } from '../types/compatibility';

// Map signs to their elements
const signToElement: Record<ZodiacSign | PlanetaryBody, Element> = {
  // Zodiac Signs
  Aries: 'Fire',
  Leo: 'Fire', 
  Sagittarius: 'Fire',
  Taurus: 'Earth',
  Virgo: 'Earth',
  Capricorn: 'Earth', 
  Gemini: 'Air',
  Libra: 'Air',
  Aquarius: 'Air',
  Cancer: 'Water',
  Scorpio: 'Water',
  Pisces: 'Water',
  // Planetary Bodies
  Sun: 'Fire',
  Moon: 'Water',
  Mercury: 'Air',
  Venus: 'Earth',
  Mars: 'Fire',
  Jupiter: 'Fire',
  Saturn: 'Earth'
};

// Element compatibility scores (out of 100)
const elementCompatibility: Record<Element, Record<Element, number>> = {
  Fire: {
    Fire: 85, // High energy but can burn out
    Earth: 75, // Fire needs Earth's stability
    Air: 90,   // Air fuels Fire's passion
    Water: 45  // Water can extinguish Fire
  },
  Earth: {
    Fire: 75,  // Earth provides grounding for Fire
    Earth: 80, // Stable but can be stagnant
    Air: 45,   // Air finds Earth too rigid
    Water: 90  // Earth and Water create growth
  },
  Air: {
    Fire: 90,  // Air and Fire create energy
    Earth: 45, // Too different in approaches
    Air: 85,   // Great mental connection
    Water: 75  // Complex but potentially transformative
  },
  Water: {
    Fire: 45,  // Too volatile together
    Earth: 90, // Perfect nurturing combo
    Air: 75,   // Deep growth potential with understanding
    Water: 95  // Deep emotional bond
  }
};

// Individual sign compatibility modifiers (-20 to +20)
const signModifiers: Record<ZodiacSign | PlanetaryBody, Record<ZodiacSign | PlanetaryBody, number>> = {
  // Zodiac Signs
  Aries: {
    Aries: 10, Leo: 15, Sagittarius: 15, Libra: 10, Gemini: 10, Aquarius: 10,
    Taurus: -10, Cancer: 0, Virgo: 0, Scorpio: 5, Capricorn: -15, Pisces: 0,
    Sun: 15, Moon: 0, Mercury: 10, Venus: -5, Mars: 15, Jupiter: 10, Saturn: -10
  },
  Leo: {
    Leo: 10, Aries: 15, Sagittarius: 15, Libra: 15, Gemini: 10, Taurus: -10,
    Cancer: 5, Virgo: 0, Scorpio: 5, Capricorn: 0, Aquarius: 5, Pisces: 0,
    Sun: 15, Moon: 5, Mercury: 5, Venus: 10, Mars: 10, Jupiter: 15, Saturn: -5
  },
  Sagittarius: {
    Sagittarius: 10, Aries: 15, Leo: 15, Gemini: 10, Libra: 10, Pisces: -10,
    Taurus: 0, Cancer: 0, Virgo: -15, Scorpio: 0, Capricorn: 5, Aquarius: 10,
    Sun: 10, Moon: 0, Mercury: 5, Venus: 0, Mars: 10, Jupiter: 15, Saturn: 0
  },
  Taurus: {
    Taurus: 10, Virgo: 15, Capricorn: 15, Cancer: 15, Pisces: 10, Aries: -10,
    Leo: -10, Gemini: -10, Libra: 5, Scorpio: 10, Sagittarius: 0, Aquarius: -15,
    Sun: -5, Moon: 10, Mercury: 0, Venus: 15, Mars: -10, Jupiter: 5, Saturn: 10
  },
  Virgo: {
    Virgo: 10, Taurus: 15, Capricorn: 15, Cancer: 10, Scorpio: 10, Sagittarius: -15,
    Aries: 0, Leo: 0, Gemini: 5, Libra: 5, Aquarius: 0, Pisces: 10,
    Sun: 0, Moon: 5, Mercury: 15, Venus: 10, Mars: -5, Jupiter: 0, Saturn: 10
  },
  Capricorn: {
    Capricorn: 10, Taurus: 15, Virgo: 15, Scorpio: 15, Pisces: 10, Aries: -15,
    Leo: 0, Gemini: 0, Cancer: 10, Libra: 5, Sagittarius: 5, Aquarius: -10,
    Sun: -5, Moon: 5, Mercury: 5, Venus: 10, Mars: -5, Jupiter: 0, Saturn: 15
  },
  Gemini: {
    Gemini: 10, Libra: 15, Aquarius: 15, Aries: 10, Leo: 10, Taurus: -10,
    Cancer: 5, Virgo: 5, Scorpio: -10, Sagittarius: 10, Capricorn: 0, Pisces: -5,
    Sun: 5, Moon: 0, Mercury: 15, Venus: 5, Mars: 5, Jupiter: 10, Saturn: 0
  },
  Libra: {
    Libra: 10, Gemini: 15, Aquarius: 15, Leo: 15, Sagittarius: 10, Cancer: -5,
    Taurus: 5, Virgo: 5, Scorpio: 10, Capricorn: 5, Aries: 10, Pisces: 10,
    Sun: 10, Moon: 5, Mercury: 10, Venus: 15, Mars: 0, Jupiter: 10, Saturn: 0
  },
  Aquarius: {
    Aquarius: 10, Gemini: 15, Libra: 15, Aries: 10, Sagittarius: 10, Taurus: -15,
    Cancer: -10, Leo: 5, Virgo: 0, Scorpio: 5, Capricorn: -10, Pisces: 10,
    Sun: 5, Moon: -5, Mercury: 10, Venus: 0, Mars: 5, Jupiter: 10, Saturn: 10
  },
  Cancer: {
    Cancer: 10, Scorpio: 15, Pisces: 15, Taurus: 15, Virgo: 10, Aquarius: -10,
    Aries: 0, Leo: 5, Gemini: 5, Libra: -5, Sagittarius: 0, Capricorn: 10,
    Sun: 0, Moon: 15, Mercury: 0, Venus: 10, Mars: -5, Jupiter: 5, Saturn: 5
  },
  Scorpio: {
    Scorpio: 10, Cancer: 15, Pisces: 15, Capricorn: 15, Virgo: 10, Gemini: -10,
    Aries: 5, Leo: 5, Taurus: 10, Libra: 10, Sagittarius: 0, Aquarius: 5,
    Sun: 5, Moon: 10, Mercury: -5, Venus: 5, Mars: 15, Jupiter: 5, Saturn: 10
  },
  Pisces: {
    Pisces: 10, Cancer: 15, Scorpio: 15, Taurus: 10, Capricorn: 10, Gemini: -5,
    Aries: 0, Leo: 0, Virgo: 10, Libra: 10, Sagittarius: -10, Aquarius: 10,
    Sun: 0, Moon: 15, Mercury: 0, Venus: 10, Mars: 0, Jupiter: 15, Saturn: 5
  },
  // Planetary Bodies
  Sun: {
    Aries: 15, Leo: 15, Sagittarius: 10, Taurus: -5, Virgo: 0, Capricorn: -5,
    Gemini: 5, Libra: 10, Aquarius: 5, Cancer: 0, Scorpio: 5, Pisces: 0,
    Sun: 15, Moon: 10, Mercury: 5, Venus: 5, Mars: 10, Jupiter: 15, Saturn: -5
  },
  Moon: {
    Aries: 0, Leo: 5, Sagittarius: 0, Taurus: 10, Virgo: 5, Capricorn: 5,
    Gemini: 0, Libra: 5, Aquarius: -5, Cancer: 15, Scorpio: 10, Pisces: 15,
    Sun: 10, Moon: 15, Mercury: 0, Venus: 10, Mars: -5, Jupiter: 5, Saturn: 0
  },
  Mercury: {
    Aries: 10, Leo: 5, Sagittarius: 5, Taurus: 0, Virgo: 15, Capricorn: 5,
    Gemini: 15, Libra: 10, Aquarius: 10, Cancer: 0, Scorpio: -5, Pisces: 0,
    Sun: 5, Moon: 0, Mercury: 15, Venus: 5, Mars: 5, Jupiter: 10, Saturn: 5
  },
  Venus: {
    Aries: -5, Leo: 10, Sagittarius: 0, Taurus: 15, Virgo: 10, Capricorn: 10,
    Gemini: 5, Libra: 15, Aquarius: 0, Cancer: 10, Scorpio: 5, Pisces: 10,
    Sun: 5, Moon: 10, Mercury: 5, Venus: 15, Mars: 0, Jupiter: 10, Saturn: 5
  },
  Mars: {
    Aries: 15, Leo: 10, Sagittarius: 10, Taurus: -10, Virgo: -5, Capricorn: -5,
    Gemini: 5, Libra: 0, Aquarius: 5, Cancer: -5, Scorpio: 15, Pisces: 0,
    Sun: 10, Moon: -5, Mercury: 5, Venus: 0, Mars: 15, Jupiter: 10, Saturn: -10
  },
  Jupiter: {
    Aries: 10, Leo: 15, Sagittarius: 15, Taurus: 5, Virgo: 0, Capricorn: 0,
    Gemini: 10, Libra: 10, Aquarius: 10, Cancer: 5, Scorpio: 5, Pisces: 15,
    Sun: 15, Moon: 5, Mercury: 10, Venus: 10, Mars: 10, Jupiter: 15, Saturn: 0
  },
  Saturn: {
    Aries: -10, Leo: -5, Sagittarius: 0, Taurus: 10, Virgo: 10, Capricorn: 15,
    Gemini: 0, Libra: 0, Aquarius: 10, Cancer: 5, Scorpio: 10, Pisces: 5,
    Sun: -5, Moon: 0, Mercury: 5, Venus: 5, Mars: -10, Jupiter: 0, Saturn: 10
  }
};

// Calculate base element compatibility score
const getElementCompatibilityScore = (sign1: ZodiacSign | PlanetaryBody, sign2: ZodiacSign | PlanetaryBody): number => {
  const element1 = signToElement[sign1];
  const element2 = signToElement[sign2];
  return elementCompatibility[element1][element2];
};

// Get sign-specific compatibility modifier
const getSignModifier = (sign1: ZodiacSign | PlanetaryBody, sign2: ZodiacSign | PlanetaryBody): number => {
  return (signModifiers[sign1]?.[sign2] || 0);
};

// Calculate overall astrological compatibility score
export const calculateAstrologicalCompatibility = (sign1: ZodiacSign | PlanetaryBody, sign2: ZodiacSign | PlanetaryBody): BaseCompatibilityScore => {
  // Get base element compatibility
  const elementScore = getElementCompatibilityScore(sign1, sign2);
  
  // Get sign-specific modifiers (both directions)
  const modifier1 = getSignModifier(sign1, sign2);
  const modifier2 = getSignModifier(sign2, sign1);
  
  // Average the modifiers
  const signModifier = (modifier1 + modifier2) / 2;
  
  return {
    elementScore,
    signModifier
  };
};

// Get detailed compatibility explanation
export const getAstrologicalCompatibilityDetails = (sign1: ZodiacSign | PlanetaryBody, sign2: ZodiacSign | PlanetaryBody): string => {
  const element1 = signToElement[sign1];
  const element2 = signToElement[sign2];
  const score = calculateAstrologicalCompatibility(sign1, sign2);
  
  let details = `${sign1} (${element1}) and ${sign2} (${element2}) Compatibility:\n\n`;
  
  // Element compatibility explanation
  if (score.elementScore >= 80) {
    details += "This is a naturally harmonious match! ";
  } else if (score.elementScore >= 60) {
    details += "This combination has good potential with some effort. ";
  } else {
    details += "This match may face some natural challenges. ";
  }
  
  // Add element interaction details
  if (element1 === element2) {
    details += `As both are ${element1} signs, they share a deep understanding of each other's core nature. `;
  } else {
    switch (element1 + "-" + element2) {
      case "Fire-Earth":
      case "Earth-Fire":
        details += "Fire brings passion and inspiration while Earth provides stability and practicality. ";
        break;
      case "Fire-Air":
      case "Air-Fire":
        details += "Fire and Air feed each other's enthusiasm and create exciting energy. ";
        break;
      case "Fire-Water":
      case "Water-Fire":
        details += "Fire and Water can create steam - intense but potentially volatile. ";
        break;
      case "Earth-Air":
      case "Air-Earth":
        details += "Earth grounds Air's ideas while Air brings fresh perspectives to Earth. ";
        break;
      case "Earth-Water":
      case "Water-Earth":
        details += "Earth and Water nurture growth and create a stable emotional foundation. ";
        break;
      case "Air-Water":
      case "Water-Air":
        details += "This combination creates an intriguing dynamic - Air brings intellectual clarity and perspective, while Water provides emotional depth and intuition. Air can help Water express and understand their feelings, while Water can teach Air to connect with their emotions. Success requires Air to respect Water's emotional needs and Water to appreciate Air's need for rational understanding. While challenging, this pairing offers great potential for growth and balance. ";
        break;
    }
  }
  
  // Add sign-specific insights
  const modifier = getSignModifier(sign1, sign2);
  if (modifier > 0) {
    details += `${sign1} and ${sign2} have particularly complementary qualities. `;
  } else if (modifier < 0) {
    details += `${sign1} and ${sign2} may need to work on understanding their differences. `;
  }
  
  return details;
};
