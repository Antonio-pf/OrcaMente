# Standard Components Documentation

## Overview

This directory contains standardized components that provide consistent styling and behavior across the OrcaMente application. All components follow the design patterns established in the quiz interface and support both light and dark themes.

## Components

### 1. StandardButton

A standardized button component with consistent styling, loading states, and icon support.

**Features:**
- Rounded corners (16px default)
- Loading state with spinner
- Disabled state handling
- Optional icon support
- Customizable colors and elevation
- Shadow effects

**Usage:**

```dart
StandardButton(
  text: 'Save',
  icon: Icons.save,
  onPressed: () {
    // Handle button press
  },
  isLoading: false,
  backgroundColor: CustomTheme.primaryColor,
  foregroundColor: Colors.white,
)
```

**Parameters:**
- `text` (required): Button label text
- `onPressed`: Callback function when pressed
- `isLoading`: Show loading spinner (default: false)
- `icon`: Optional icon to display
- `backgroundColor`: Button background color
- `foregroundColor`: Text and icon color
- `disabledBackgroundColor`: Background when disabled
- `disabledForegroundColor`: Text color when disabled
- `borderRadius`: Corner radius (default: 16)
- `padding`: Internal padding
- `elevation`: Shadow depth (default: 4)
- `shadowColor`: Shadow color

---

### 2. StandardIconButton

A circular icon button for navigation and simple actions.

**Features:**
- Circular shape
- Border styling
- Customizable size
- Ink splash effect

**Usage:**

```dart
StandardIconButton(
  icon: Icons.arrow_back_ios_new_rounded,
  onPressed: () => Navigator.pop(context),
  backgroundColor: Color(0xFFF5F5F5),
  iconColor: Color(0xFF424242),
  size: 48,
)
```

**Parameters:**
- `icon` (required): Icon to display
- `onPressed`: Callback function
- `backgroundColor`: Button background
- `iconColor`: Icon color
- `size`: Button diameter (default: 48)
- `borderColor`: Border color

---

### 3. StandardCard

A container component with consistent card styling.

**Features:**
- Rounded corners (16px default)
- Subtle shadows
- Optional gradient backgrounds
- Responsive padding
- Theme-aware coloring

**Usage:**

```dart
StandardCard(
  backgroundColor: isDark 
      ? CustomTheme.neutralBlack.withOpacity(0.5)
      : Colors.white,
  child: Column(
    children: [
      Text('Card Content'),
      // More content...
    ],
  ),
)
```

**Parameters:**
- `child` (required): Widget to display inside card
- `backgroundColor`: Card background color
- `padding`: Internal padding (default: EdgeInsets.all(20))
- `borderRadius`: Corner radius (default: 16)
- `shadows`: Custom shadow list
- `border`: Border styling
- `gradient`: Optional gradient background

---

### 4. IconBadge

A small icon container for card headers and indicators.

**Features:**
- Rounded corners (12px)
- Color-coded backgrounds
- Consistent sizing
- Padding

**Usage:**

```dart
IconBadge(
  icon: Icons.school_outlined,
  iconColor: CustomTheme.primaryColor,
  backgroundColor: CustomTheme.primaryColor.withOpacity(0.1),
  size: 20,
)
```

**Parameters:**
- `icon` (required): Icon to display
- `iconColor` (required): Icon color
- `backgroundColor`: Background color (default: iconColor.withOpacity(0.1))
- `size`: Icon size (default: 20)

---

### 5. StandardHeader

A standardized header component with back button, title, and optional badges.

**Features:**
- Optional back button
- Title and subtitle
- Badge support (e.g., location)
- Sticky behavior
- Shadow effects

**Usage:**

```dart
StandardHeader(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  showBackButton: true,
  onBackPressed: () => Navigator.pop(context),
  badge: LocationBadge(locationName: 'São Paulo'),
)
```

**Parameters:**
- `title` (required): Main heading text
- `subtitle`: Optional subtitle text
- `onBackPressed`: Back button callback
- `badge`: Optional badge widget
- `showBackButton`: Show/hide back button (default: true)

---

### 6. LocationBadge

A badge component for displaying location information.

**Features:**
- Location icon
- Rounded pill shape
- Border styling
- Shadow effect

**Usage:**

```dart
LocationBadge(
  locationName: 'São Paulo',
  icon: Icons.location_on,
  iconColor: Color(0xFF10B981),
)
```

---

### 7. StatusBadge

A badge for displaying status information.

**Features:**
- Optional icon
- Color-coded backgrounds
- Rounded shape
- Compact size

**Usage:**

```dart
StatusBadge(
  text: 'Active',
  icon: Icons.check_circle,
  backgroundColor: Color(0xFFE8F5E9),
  textColor: Color(0xFF1B5E20),
  iconColor: Color(0xFF10B981),
)
```

---

## Theme Integration

All components automatically adapt to the app's theme using `CustomTheme` colors:

- `primaryColor`: Main brand color (green #10B981)
- `primaryDark`: Dark variant (#065F46)
- `primaryLight`: Light variant (#6EE7B7)
- `secondaryColor`: Secondary accent (blue #0EA5E9)
- `neutralBlack`: Dark mode backgrounds (#111827)
- `neutralWhite`: Light backgrounds (#FFFFFF)
- `successColor`: Success states (#10B981)
- `errorColor`: Error states (#EF4444)
- `warningColor`: Warning states (#F59E0B)

## Dark Mode Support

All components support dark mode through the `Theme.of(context).brightness` check:

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

StandardCard(
  backgroundColor: isDark 
      ? CustomTheme.neutralBlack.withOpacity(0.5)
      : Colors.white,
  child: content,
)
```

## Best Practices

1. **Consistency**: Always use standard components instead of creating custom buttons/cards
2. **Theme Colors**: Use `CustomTheme` colors for consistency
3. **Dark Mode**: Always consider both light and dark themes
4. **Accessibility**: Ensure sufficient contrast ratios (4.5:1 minimum for text)
5. **Touch Targets**: Maintain minimum 48x48 touch areas for buttons
6. **Loading States**: Use `isLoading` parameter for async operations
7. **Error Handling**: Provide clear feedback with disabled states and error messages

## Migration Guide

To migrate existing components to use standard components:

1. Replace custom `ElevatedButton` with `StandardButton`
2. Replace custom `Container` cards with `StandardCard`
3. Use `StandardIconButton` for back buttons
4. Wrap icon indicators in `IconBadge`
5. Update colors to use `CustomTheme` constants

## Examples

### Complete Form with Standard Components

```dart
StandardCard(
  child: Column(
    children: [
      StandardHeader(
        title: 'User Profile',
        subtitle: 'Update your information',
      ),
      SizedBox(height: 20),
      IconBadge(
        icon: Icons.person,
        iconColor: CustomTheme.primaryColor,
      ),
      SizedBox(height: 20),
      // Form fields...
      StandardButton(
        text: 'Save Changes',
        icon: Icons.save,
        onPressed: () => _saveProfile(),
        isLoading: _isSaving,
      ),
    ],
  ),
)
```

### Settings Page Example

```dart
StandardCard(
  child: Column(
    children: [
      Row(
        children: [
          IconBadge(
            icon: Icons.settings,
            iconColor: CustomTheme.primaryColor,
          ),
          SizedBox(width: 12),
          Text('Preferences'),
        ],
      ),
      // Settings content...
    ],
  ),
)
```

## Maintenance

When updating standard components:
1. Update this documentation
2. Test in both light and dark themes
3. Verify on multiple screen sizes
4. Check accessibility with screen readers
5. Update all usages across the app

## Support

For questions or issues with standard components, contact the development team or create an issue in the project repository.
