import React from 'react';
import { View, TextInput, StyleSheet } from 'react-native';

// Simple web implementation of DateTimePicker
export default function DateTimePicker(props) {
  const {
    value = new Date(),
    mode = 'date',
    display,
    onChange,
    minimumDate,
    maximumDate,
    minuteInterval,
    timeZoneOffsetInMinutes,
    locale,
    is24Hour,
    neutralButtonLabel,
    testID,
    ...otherProps
  } = props;

  // Format date as YYYY-MM-DD for date inputs
  const formatDate = (date) => {
    const d = new Date(date);
    let month = '' + (d.getMonth() + 1);
    let day = '' + d.getDate();
    const year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
  };

  // Format time as HH:MM for time inputs
  const formatTime = (date) => {
    const d = new Date(date);
    let hours = '' + d.getHours();
    let minutes = '' + d.getMinutes();

    if (hours.length < 2) hours = '0' + hours;
    if (minutes.length < 2) minutes = '0' + minutes;

    return [hours, minutes].join(':');
  };

  // Handle date change
  const handleChange = (e) => {
    if (!onChange) return;

    const newValue = e.target.value;
    const oldDate = new Date(value);
    
    let newDate;
    if (mode === 'date') {
      const [year, month, day] = newValue.split('-').map(Number);
      newDate = new Date(oldDate);
      newDate.setFullYear(year);
      newDate.setMonth(month - 1);
      newDate.setDate(day);
    } else if (mode === 'time') {
      const [hours, minutes] = newValue.split(':').map(Number);
      newDate = new Date(oldDate);
      newDate.setHours(hours);
      newDate.setMinutes(minutes);
    } else if (mode === 'datetime') {
      newDate = new Date(newValue);
    }

    onChange({ type: 'set', nativeEvent: { timestamp: newDate.getTime() } });
  };

  // Determine input type and format based on mode
  let inputType = 'text';
  let inputValue = '';
  
  if (mode === 'date') {
    inputType = 'date';
    inputValue = formatDate(value);
  } else if (mode === 'time') {
    inputType = 'time';
    inputValue = formatTime(value);
  } else if (mode === 'datetime') {
    inputType = 'datetime-local';
    inputValue = `${formatDate(value)}T${formatTime(value)}`;
  }

  // Apply min/max dates if provided
  const minValue = minimumDate ? formatDate(minimumDate) : undefined;
  const maxValue = maximumDate ? formatDate(maximumDate) : undefined;

  return (
    <View style={styles.container}>
      <TextInput
        {...otherProps}
        style={styles.input}
        value={inputValue}
        onChange={handleChange}
        testID={testID}
        // Web-specific props
        type={inputType}
        min={minValue}
        max={maxValue}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
  },
  input: {
    height: 40,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 4,
    paddingHorizontal: 8,
  },
});
