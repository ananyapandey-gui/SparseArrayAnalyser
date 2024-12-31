# SparseArrayAnalyser
This repository contains the code, instructions, and details for the developed GUI, providing everything needed for easy access and use.
Here’s a well-structured `README.md` for your repository:

---

```markdown
# SensorArrayApp

This repository contains a MATLAB App Designer application for analyzing difference coarrays and weight functions in sparse linear sensor arrays. The app allows users to input array configurations and visualize key properties, including weight functions and coarray characteristics.

---

## Features
- **Input Modes**: Supports both IES Notation and explicit Sensor Positions as input.
- **Visualization**: Plots the weight function graph with spatial lags and corresponding weights.
- **Analysis**:
  - Computes difference coarray and associated weights.
  - Determines whether the coarray is hole-free.
  - Displays the primary weights: w(1), w(2), and w(3).
- **User-Friendly Interface**: Designed with MATLAB App Designer for ease of use.

---

## Requirements
- **MATLAB Version**: R2021b or later.
- **Toolbox**: MATLAB App Designer must be installed.

---

## How to Use
1. Clone or download this repository:
   ```bash
   git clone https://github.com/ananyapandey-gui/SensorArrayApp.git
   ```
2. Open `SensorArrayApp.m` in MATLAB.
3. Click **Run** to launch the GUI.
4. Select the input mode (IES Notation or Sensor Positions).
5. Enter the respective data and press **Process** to analyze and visualize the results.

---

## File Structure
- `SensorArrayApp.m`: Main MATLAB App Designer code for the GUI.
- *(Optional)* `screenshot.png`: Example visualization of the app (add if needed).
- `README.md`: Documentation for the repository.

---

## Example Inputs
- **IES Notation**: `[3, 1, 4, 2]`  
  - Input this sequence in the `IES Notation` field.
- **Sensor Positions**: `[0, 1, 4, 7]`  
  - Input this sequence in the `Sensor Positions` field.

---

## Outputs
- **Sensor Positions**: Displays the parsed or entered positions.
- **Difference Coarray**: Lists the unique spatial lags.
- **Main Weights**: Provides the primary weight values for w(1), w(2), and w(3).
- **Graph**: Plots the weight function with spatial lags and their respective weights.
- **Status**: Indicates whether the coarray is hole-free.

---

## Screenshot
![image](https://github.com/user-attachments/assets/304b59e2-41bd-45db-9f1b-9e7c79774560)


---



---

## License
This project is licensed under the [MIT License](LICENSE).

---

## Contact
For questions or feedback, please contact: ananyapandeyrule@gmail.com
```

