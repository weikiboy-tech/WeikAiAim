<div align="center">

# WeikAiAim

  <p>
    <img width="75%" src="https://raw.githubusercontent.com/weikiboy-tech/WeikAiAim/main/media/one.gif">
  </p>
</div>

## Overview
WeikAiAim is an AI-powered aim bot for first-person shooter games. It leverages the YOLOv8 and YOLOv10 models, PyTorch, and various other tools to automatically target and aim at enemies.

> [!WARNING]
> Use it at your own risk, we do not guarantee that you may be blocked!

> [!NOTE]
> The recommended graphics card for starting and more productive and stable operation starts with the rtx 20 series.

## Beispielvorschau
![Beispielvorschau](https://raw.githubusercontent.com/weikiboy-tech/WeikAiAim/main/media/one.gif)

## Requirements
Before you get started, make sure you have the following prerequisites installed.

- Python 3.12.0
- PyTorch
- YOLOv8/YOLOv10
- CUDA 12.8 (recommended)
- TensorRT 10.13.0.35 (optional, for acceleration)

<br></br>
- To install everything with one click, run `install_all_requirements.bat`.
- Start both components using these two batch files:
  - `run_ai.bat` (Aimbot)
  - `run_helper.bat` (Helper UI + API)
- On Ubuntu/Linux, use `bash run_ai.sh` or `bash run_helper.sh`.

### Ubuntu / Linux
- Use Python 3.12 in a virtual environment and install dependencies with `python -m pip install -r requirements.txt`.
- Use `mss_capture = True` or `Obs_capture = True`; BetterCam, GHUB and Razer DLL input are Windows-only.
- Native Linux hotkeys/mouse input use `pynput` and require an X11 session with input permissions. Wayland sessions can block global input and screen capture.
- CUDA installation is not automated by the helper on Ubuntu. Install NVIDIA driver/CUDA with your package manager or NVIDIA's Linux installer, then install the matching PyTorch build.
- Launch with `python run.py`. The `.bat` launchers are Windows-only.

## Working environment:
<table>
  <thead><tr><th>Windows</th><td>10 and 11 (priority)</td></thead>
  <thead><tr><th>Python:</th><td>3.12.0</td></tr></thead>
  <thead><tr><th>CUDA:</th><td>12.8</td></tr></thead>
  <thead><tr><th>TensorRT:</th><td>10.13.0.35</td></tr></thead>
  <thead><tr><th>Ultralytics:</th><td>8.3.174</td></tr></thead>
  <thead><tr><th>GitHub AI Model:</th><td>sunxds_0.8.0</td></tr></thead>
  <thead><tr><th>Supporters AI Model:</th><td>sunxds_0.8.2</td></tr></thead>
</table>

## Notes / Recommendations
- Limit the maximum value of frames per second in the game in which you will use it. Do not set the screen resolution too high. Do not overload the graphics card.
- Do not set high graphics settings in games.
- Limit the browser (try not to watch YouTube while playing and working AI at the same time).
- Try to use TensorRT for acceleration. `.pt` model is good, but does not have as much speed as `.engine`.
- Turn off the cv2 debug window, this saves system resources.
- Do not increase the object search window resolution, this may affect your search speed.
- If you have started the application and nothing happens, it may be working, close it with the F2 key and change the `show_window` option to `True` in the config file.
