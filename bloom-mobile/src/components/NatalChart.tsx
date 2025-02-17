import React, { useState } from 'react';
import {
  YStack,
  XStack,
  Text,
  Card,
  Button,
  styled,
} from 'tamagui';

type ChartMode = 'TABLE' | 'CIRCLE';

type NatalChartProps = {
  data: {
    signs: {
      [key: string]: string;
    };
    planets: {
      [key: string]: {
        planet: string;
        house: number;
      };
    };
  };
};

const ChartContainer = styled(Card, {
  backgroundColor: '$backgroundStrong',
  padding: '$4',
  marginVertical: '$2',
});

const ToggleContainer = styled(XStack, {
  justifyContent: 'center',
  marginBottom: '$4',
  backgroundColor: '$background',
  borderRadius: '$4',
  padding: '$1',
});

const ToggleButton = styled(Button, {
  paddingVertical: '$2',
  paddingHorizontal: '$4',
  borderRadius: '$3',
  backgroundColor: 'transparent',
  
  variants: {
    active: {
      true: {
        backgroundColor: '$backgroundHover',
      },
    },
  },
});

const ToggleText = styled(Text, {
  color: '$gray10',
  fontSize: '$3',
  fontWeight: 'bold',
  fontFamily: '$body',
  
  variants: {
    active: {
      true: {
        color: '$text',
      },
    },
  },
});

const TableContainer = styled(YStack, {
  borderRadius: '$4',
  overflow: 'hidden',
});

const TableHeader = styled(XStack, {
  backgroundColor: '$background',
  paddingVertical: '$3',
  paddingHorizontal: '$4',
});

const ColumnHeader = styled(Text, {
  flex: 1,
  color: '$primary',
  fontSize: '$2',
  fontWeight: 'bold',
  fontFamily: '$body',
});

const TableRow = styled(XStack, {
  borderBottomWidth: 1,
  borderBottomColor: '$borderColor',
  paddingVertical: '$3',
  paddingHorizontal: '$4',
});

const CellText = styled(Text, {
  flex: 1,
  color: '$text',
  fontSize: '$3',
  fontFamily: '$body',
});

const CircleContainer = styled(YStack, {
  aspectRatio: 1,
  justifyContent: 'center',
  alignItems: 'center',
});

const ComingSoonText = styled(Text, {
  color: '$gray10',
  fontSize: '$4',
  fontFamily: '$body',
});

export default function NatalChart({ data }: NatalChartProps) {
  const [mode, setMode] = useState<ChartMode>('TABLE');

  const renderTable = () => (
    <TableContainer>
      <TableHeader>
        <ColumnHeader>SIGNS</ColumnHeader>
        <ColumnHeader>PLANETS</ColumnHeader>
        <ColumnHeader>HOUSES</ColumnHeader>
      </TableHeader>
      {Object.entries(data.planets).map(([key, value], index) => (
        <TableRow key={key}>
          <CellText>{data.signs[key] || ''}</CellText>
          <CellText>{value.planet}</CellText>
          <CellText>{value.house}</CellText>
        </TableRow>
      ))}
    </TableContainer>
  );

  const renderCircle = () => (
    <CircleContainer>
      <ComingSoonText>Circle view coming soon</ComingSoonText>
    </CircleContainer>
  );

  return (
    <ChartContainer elevate>
      <ToggleContainer>
        <ToggleButton
          active={mode === 'TABLE'}
          onPress={() => setMode('TABLE')}
          animation="quick"
          pressStyle={{ opacity: 0.8 }}
        >
          <ToggleText active={mode === 'TABLE'}>
            TABLE
          </ToggleText>
        </ToggleButton>
        <ToggleButton
          active={mode === 'CIRCLE'}
          onPress={() => setMode('CIRCLE')}
          animation="quick"
          pressStyle={{ opacity: 0.8 }}
        >
          <ToggleText active={mode === 'CIRCLE'}>
            CIRCLE
          </ToggleText>
        </ToggleButton>
      </ToggleContainer>
      {mode === 'TABLE' ? renderTable() : renderCircle()}
    </ChartContainer>
  );
}
